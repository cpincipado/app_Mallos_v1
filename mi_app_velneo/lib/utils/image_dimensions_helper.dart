// lib/utils/image_dimensions_helper.dart - DETECCIÓN AUTOMÁTICA DE DIMENSIONES CORREGIDA

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:http/http.dart' as http;

/// ✅ UTILITY CLASS para detección automática de dimensiones de imágenes
class ImageDimensionsHelper {
  // ✅ CACHE EN MEMORIA para evitar recálculos
  static final Map<String, Size> _dimensionsCache = {};

  /// ✅ LOGGING CONDICIONAL
  static void _log(String message) {
    if (kDebugMode) {
      debugPrint('ImageDimensionsHelper: $message');
    }
  }

  /// ✅ OBTENER DIMENSIONES DE IMAGEN - CON CACHE Y FALLBACK ROBUSTO
  static Future<Size> getImageDimensions(String imageUrl) async {
    // Verificar cache primero
    if (_dimensionsCache.containsKey(imageUrl)) {
      _log('✅ Dimensiones desde CACHE: $imageUrl');
      return _dimensionsCache[imageUrl]!;
    }

    try {
      late Size dimensions;

      if (imageUrl.startsWith('assets/')) {
        // ✅ IMAGEN LOCAL (ASSET) - Método simplificado
        dimensions = await _getAssetImageDimensionsSimple(imageUrl);
      } else if (imageUrl.startsWith('http')) {
        // ✅ IMAGEN REMOTA (URL)
        dimensions = await _getNetworkImageDimensions(imageUrl);
      } else {
        _log('❌ URL de imagen no soportada: $imageUrl');
        return _getFallbackSize();
      }

      // ✅ VALIDAR DIMENSIONES
      if (dimensions.width <= 0 || dimensions.height <= 0) {
        _log(
          '❌ Dimensiones inválidas detectadas: ${dimensions.width}x${dimensions.height}',
        );
        return _getFallbackSize();
      }

      // ✅ GUARDAR EN CACHE
      _dimensionsCache[imageUrl] = dimensions;
      _log(
        '✅ Dimensiones detectadas: $imageUrl -> ${dimensions.width}x${dimensions.height}',
      );

      return dimensions;
    } catch (e) {
      _log('❌ Error detectando dimensiones: $imageUrl -> $e');
      // ✅ FALLBACK: Aspect ratio 16:9
      final fallback = _getFallbackSize();
      _dimensionsCache[imageUrl] = fallback;
      return fallback;
    }
  }

  /// ✅ MÉTODO SIMPLIFICADO PARA ASSETS LOCALES
  static Future<Size> _getAssetImageDimensionsSimple(String assetPath) async {
    try {
      // ✅ USAR TIMEOUT PARA EVITAR BLOQUEOS
      final completer = Completer<Size>();

      // Crear el widget de imagen para obtener dimensiones
      final image = Image.asset(assetPath);
      final imageStream = image.image.resolve(const ImageConfiguration());

      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          final size = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
          imageStream.removeListener(listener);
          if (!completer.isCompleted) {
            completer.complete(size);
          }
        },
        onError: (exception, stackTrace) {
          imageStream.removeListener(listener);
          if (!completer.isCompleted) {
            completer.completeError(exception);
          }
        },
      );

      imageStream.addListener(listener);

      // ✅ TIMEOUT de 5 segundos
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          _log('⏰ Timeout obteniendo dimensiones de asset: $assetPath');
          return _getFallbackSize();
        },
      );
    } catch (e) {
      _log('❌ Error en asset dimensions: $e');
      return _getFallbackSize();
    }
  }

  /// ✅ OBTENER DIMENSIONES DE IMAGEN REMOTA
  static Future<Size> _getNetworkImageDimensions(String imageUrl) async {
    try {
      // ✅ TIMEOUT PARA REQUESTS
      final response = await http
          .get(
            Uri.parse(imageUrl),
            headers: {'User-Agent': 'DistritoMallos/1.0'},
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              _log('⏰ Timeout descargando imagen: $imageUrl');
              throw Exception('Timeout downloading image');
            },
          );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: Failed to load image');
      }

      final Uint8List bytes = response.bodyBytes;
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frame = await codec.getNextFrame();

      return Size(frame.image.width.toDouble(), frame.image.height.toDouble());
    } catch (e) {
      _log('❌ Error en network dimensions: $e');
      return _getFallbackSize();
    }
  }

  /// ✅ TAMAÑO FALLBACK CONFIABLE
  static Size _getFallbackSize() {
    return const Size(16, 9); // Aspect ratio 16:9 por defecto
  }

  /// ✅ DETERMINAR ORIENTACIÓN DE LA IMAGEN
  static ImageOrientation getImageOrientation(Size imageSize) {
    final aspectRatio = getAspectRatio(imageSize);

    if (aspectRatio > 1.2) {
      return ImageOrientation.horizontal;
    } else if (aspectRatio < 0.8) {
      return ImageOrientation.vertical;
    } else {
      return ImageOrientation.square;
    }
  }

  /// ✅ CALCULAR ASPECT RATIO SEGURO
  static double getAspectRatio(Size imageSize) {
    if (imageSize.height == 0 || !imageSize.height.isFinite) {
      return 16 / 9; // Fallback seguro
    }
    final ratio = imageSize.width / imageSize.height;
    return ratio.isFinite ? ratio : 16 / 9;
  }

  /// ✅ VERIFICAR SI ES IMAGEN HORIZONTAL
  static bool isHorizontalImage(Size imageSize) {
    return getImageOrientation(imageSize) == ImageOrientation.horizontal;
  }

  /// ✅ VERIFICAR SI ES IMAGEN VERTICAL
  static bool isVerticalImage(Size imageSize) {
    return getImageOrientation(imageSize) == ImageOrientation.vertical;
  }

  /// ✅ VERIFICAR SI ES IMAGEN CUADRADA
  static bool isSquareImage(Size imageSize) {
    return getImageOrientation(imageSize) == ImageOrientation.square;
  }

  /// ✅ CALCULAR DIMENSIONES ADAPTATIVAS PARA CONTENEDOR
  static Size calculateAdaptiveContainerSize({
    required Size imageSize,
    required Size maxConstraints,
    required Size minConstraints,
  }) {
    // ✅ VALIDAR INPUTS
    if (!_isValidSize(imageSize) ||
        !_isValidSize(maxConstraints) ||
        !_isValidSize(minConstraints)) {
      _log('❌ Tamaños inválidos en calculateAdaptiveContainerSize');
      return Size(maxConstraints.width, maxConstraints.height / 2);
    }

    final aspectRatio = getAspectRatio(imageSize);
    final orientation = getImageOrientation(imageSize);

    double width, height;

    switch (orientation) {
      case ImageOrientation.horizontal:
        // ✅ IMAGEN HORIZONTAL: Priorizar ancho
        width = maxConstraints.width;
        height = width / aspectRatio;

        // Verificar límites
        if (height > maxConstraints.height) {
          height = maxConstraints.height;
          width = height * aspectRatio;
        }

        // Aplicar mínimos
        if (width < minConstraints.width) width = minConstraints.width;
        if (height < minConstraints.height) height = minConstraints.height;

        break;

      case ImageOrientation.vertical:
        // ✅ IMAGEN VERTICAL: Priorizar altura
        height = maxConstraints.height;
        width = height * aspectRatio;

        // Verificar límites
        if (width > maxConstraints.width) {
          width = maxConstraints.width;
          height = width / aspectRatio;
        }

        // Aplicar mínimos
        if (width < minConstraints.width) width = minConstraints.width;
        if (height < minConstraints.height) height = minConstraints.height;

        break;

      case ImageOrientation.square:
        // ✅ IMAGEN CUADRADA: Usar el menor de los máximos
        final minDimension = maxConstraints.width < maxConstraints.height
            ? maxConstraints.width
            : maxConstraints.height;

        width = minDimension;
        height = minDimension;

        // Aplicar mínimos
        final minRequired = minConstraints.width > minConstraints.height
            ? minConstraints.width
            : minConstraints.height;

        if (width < minRequired) {
          width = minRequired;
          height = minRequired;
        }

        break;
    }

    // ✅ VALIDACIÓN FINAL
    if (!width.isFinite || !height.isFinite || width <= 0 || height <= 0) {
      _log('❌ Dimensiones calculadas inválidas: ${width}x$height');
      return Size(maxConstraints.width, maxConstraints.height / 2);
    }

    return Size(width, height);
  }

  /// ✅ VALIDAR QUE UN SIZE SEA VÁLIDO
  static bool _isValidSize(Size size) {
    return size.width.isFinite &&
        size.height.isFinite &&
        size.width > 0 &&
        size.height > 0;
  }

  /// ✅ LIMPIAR CACHE (útil para pruebas o liberación de memoria)
  static void clearCache() {
    _dimensionsCache.clear();
    _log('🧹 Cache de dimensiones limpiado');
  }

  /// ✅ OBTENER ESTADÍSTICAS DEL CACHE
  static Map<String, dynamic> getCacheStats() {
    return {
      'cachedImages': _dimensionsCache.length,
      'memoryUsage': '${(_dimensionsCache.length * 16)} bytes', // Aproximado
    };
  }
}

/// ✅ ENUM PARA ORIENTACIÓN DE IMAGEN
enum ImageOrientation { horizontal, vertical, square }

/// ✅ EXTENSION PARA FACILITAR EL USO
extension ImageSizeExtensions on Size {
  /// Obtiene la orientación de esta imagen
  ImageOrientation get orientation =>
      ImageDimensionsHelper.getImageOrientation(this);

  /// Obtiene el aspect ratio de esta imagen
  double get aspectRatio => ImageDimensionsHelper.getAspectRatio(this);

  /// Verifica si es imagen horizontal
  bool get isHorizontal => ImageDimensionsHelper.isHorizontalImage(this);

  /// Verifica si es imagen vertical
  bool get isVertical => ImageDimensionsHelper.isVerticalImage(this);

  /// Verifica si es imagen cuadrada
  bool get isSquare => ImageDimensionsHelper.isSquareImage(this);
}
