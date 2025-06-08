// lib/utils/image_helper.dart - Helper para manejo de imágenes
import 'package:flutter/material.dart';

class ImageHelper {
  // ✅ FORMATOS SOPORTADOS
  static const List<String> supportedFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
  ];

  // ✅ VERIFICAR SI UN FORMATO ES SOPORTADO
  static bool isSupportedFormat(String url) {
    if (url.isEmpty) return false;

    final extension = url.split('.').last.toLowerCase();
    return supportedFormats.contains(extension);
  }

  // ✅ WIDGET DE IMAGEN INTELIGENTE
  static Widget buildSmartImage({
    required String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // Sin imagen
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder(width, height, 'Sin imagen');
    }

    // Imagen local (assets)
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
              _buildErrorWidget(width, height, 'Error al cargar imagen local');
        },
      );
    }

    // Imagen de red (URL)
    if (imageUrl.startsWith('http')) {
      // Verificar formato soportado
      if (!isSupportedFormat(imageUrl)) {
        return _buildErrorWidget(width, height, 'Formato no soportado');
      }

      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildLoadingWidget(width, height);
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
              _buildErrorWidget(width, height, 'Error al cargar imagen');
        },
      );
    }

    return _buildErrorWidget(width, height, 'URL de imagen inválida');
  }

  // ✅ PLACEHOLDER MIENTRAS CARGA
  static Widget _buildLoadingWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  // ✅ PLACEHOLDER CUANDO NO HAY IMAGEN
  static Widget _buildPlaceholder(
    double? width,
    double? height,
    String message,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: (height != null && height < 100) ? 24 : 48,
            color: Colors.grey.shade400,
          ),
          if (height == null || height > 60) ...[
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // ✅ ERROR WIDGET
  static Widget _buildErrorWidget(
    double? width,
    double? height,
    String message,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: (height != null && height < 100) ? 24 : 48,
            color: Colors.red.shade400,
          ),
          if (height == null || height > 60) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                message,
                style: TextStyle(color: Colors.red.shade600, fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ✅ OPTIMIZAR TAMAÑO DE IMAGEN PARA PERFORMANCE
  static String optimizeImageUrl(
    String originalUrl, {
    int? width,
    int? height,
    int quality = 80,
  }) {
    // Para servicios como Cloudinary, ImageKit, etc.
    // Ejemplo con parámetros de optimización:

    if (originalUrl.contains('cloudinary.com')) {
      // Cloudinary optimization
      String optimization = '';
      if (width != null) optimization += 'w_$width,';
      if (height != null) optimization += 'h_$height,';
      optimization += 'q_$quality,f_auto';

      return originalUrl.replaceFirst('/upload/', '/upload/$optimization/');
    }

    if (originalUrl.contains('imagekit.io')) {
      // ImageKit optimization
      String params = '?';
      if (width != null) params += 'w=$width&';
      if (height != null) params += 'h=$height&';
      params += 'q=$quality&f=auto';

      return originalUrl + params;
    }

    // Sin optimización para otros servicios
    return originalUrl;
  }

  // ✅ CONVERTIR HEIC/HEIF (si tienes un servicio de conversión)
  static String convertUnsupportedFormat(String originalUrl) {
    // Si tu backend puede convertir formatos automáticamente
    if (originalUrl.toLowerCase().contains('.heic') ||
        originalUrl.toLowerCase().contains('.heif')) {
      return originalUrl.replaceAll(
        RegExp(r'\.(heic|heif)$', caseSensitive: false),
        '.jpg',
      );
    }

    return originalUrl;
  }
}
