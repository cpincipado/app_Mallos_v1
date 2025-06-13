// lib/services/api_service.dart - SERVICIO API SEPARADO
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mi_app_velneo/config/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Realizar petición GET
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final uri = Uri.parse(url);
      print('🌐 API GET: $url'); // Debug log
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(milliseconds: AppConstants.connectionTimeout),
      );

      print('📡 Response status: ${response.statusCode}'); // Debug log
      print('📄 Response body: ${response.body}'); // Debug log

      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        message: AppConstants.networkErrorMessage,
        statusCode: 0,
      );
    } on http.ClientException {
      throw ApiException(
        message: AppConstants.networkErrorMessage,
        statusCode: 0,
      );
    } catch (e) {
      print('❌ API Error: $e'); // Debug log
      throw ApiException(
        message: AppConstants.unknownErrorMessage,
        statusCode: 0,
      );
    }
  }

  /// Realizar petición POST
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      final uri = Uri.parse(url);
      print('🌐 API POST: $url'); // Debug log
      print('📤 Data: ${jsonEncode(data)}'); // Debug log
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(
        const Duration(milliseconds: AppConstants.connectionTimeout),
      );

      print('📡 Response status: ${response.statusCode}'); // Debug log
      print('📄 Response body: ${response.body}'); // Debug log

      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        message: AppConstants.networkErrorMessage,
        statusCode: 0,
      );
    } on http.ClientException {
      throw ApiException(
        message: AppConstants.networkErrorMessage,
        statusCode: 0,
      );
    } catch (e) {
      print('❌ API Error: $e'); // Debug log
      throw ApiException(
        message: AppConstants.unknownErrorMessage,
        statusCode: 0,
      );
    }
  }

  /// Procesar respuesta HTTP
  static Map<String, dynamic> _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    // Intentar decodificar JSON
    Map<String, dynamic> decodedResponse;
    try {
      decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      // Si no es JSON válido, crear estructura básica
      decodedResponse = {
        'success': statusCode >= 200 && statusCode < 300,
        'message': response.body,
        'data': response.body,
        'status_code': statusCode,
      };
    }

    // Verificar códigos de estado HTTP
    if (statusCode >= 200 && statusCode < 300) {
      // Éxito
      return decodedResponse;
    } else if (statusCode >= 400 && statusCode < 500) {
      // Error del cliente
      throw ApiException(
        message: decodedResponse['message'] ?? 'Error en la petición',
        statusCode: statusCode,
        data: decodedResponse,
      );
    } else if (statusCode >= 500) {
      // Error del servidor
      throw ApiException(
        message: AppConstants.serverErrorMessage,
        statusCode: statusCode,
        data: decodedResponse,
      );
    } else {
      // Otros errores
      throw ApiException(
        message: AppConstants.unknownErrorMessage,
        statusCode: statusCode,
        data: decodedResponse,
      );
    }
  }

  /// Verificar conectividad
  static Future<bool> checkConnectivity() async {
    try {
      final result = await http.get(
        Uri.parse('${AppConstants.baseUrl}/health'),
      ).timeout(const Duration(seconds: 5));
      
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// Excepción personalizada para errores de API
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  const ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Response wrapper para estandarizar respuestas
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      statusCode: json['status_code'],
    );
  }
}