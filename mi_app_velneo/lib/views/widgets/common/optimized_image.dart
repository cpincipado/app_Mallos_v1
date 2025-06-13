// lib/views/widgets/common/optimized_image.dart - COMPLETO PARA URLs REMOTAS
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OptimizedImage extends StatelessWidget {
  final String assetPath; // Ahora puede ser URL remota o asset local
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? fallback;
  final String? semanticsLabel;
  final bool enableCache;

  const OptimizedImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallback,
    this.semanticsLabel,
    this.enableCache = true,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Determinar si es URL remota o asset local
    final isNetworkImage = assetPath.startsWith('http://') || assetPath.startsWith('https://');
    
    if (isNetworkImage) {
      return _buildNetworkImage(context);
    } else {
      return _buildAssetImage(context);
    }
  }

  /// ✅ Widget para imágenes remotas (URLs)
  Widget _buildNetworkImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: assetPath,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildLoadingPlaceholder(context),
      errorWidget: (context, url, error) {
        debugPrint('❌ Error loading network image: $assetPath - $error');
        return fallback ?? _buildDefaultFallback(context);
      },
      memCacheWidth: enableCache ? _getCacheWidth(context) : null,
      memCacheHeight: enableCache ? _getCacheHeight(context) : null,
    );
  }

  /// ✅ Widget para assets locales
  Widget _buildAssetImage(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticsLabel,
      cacheWidth: enableCache ? _getCacheWidth(context) : null,
      cacheHeight: enableCache ? _getCacheHeight(context) : null,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Error loading asset image: $assetPath - $error');
        return fallback ?? _buildDefaultFallback(context);
      },
    );
  }

  /// ✅ Placeholder mientras carga la imagen
  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  // Calcular tamaño de cache para optimizar memoria
  int? _getCacheWidth(BuildContext context) {
    if (width == null) return null;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return (width! * devicePixelRatio).round();
  }

  int? _getCacheHeight(BuildContext context) {
    if (height == null) return null;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return (height! * devicePixelRatio).round();
  }

  Widget _buildDefaultFallback(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        size: _calculateIconSize(),
        color: Colors.grey.shade400,
      ),
    );
  }

  double _calculateIconSize() {
    if (width != null && height != null) {
      return (width! < height! ? width! * 0.3 : height! * 0.3);
    }
    return 24;
  }
}

// ===============================================
// WIDGETS ESPECÍFICOS PARA TU APP (CORREGIDOS)
// ===============================================

class DistritoMallosLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit fit;

  const DistritoMallosLogo({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedImage(
      assetPath: 'assets/images/distrito_mallos_logo.png',
      height: height,
      width: width,
      fit: fit,
      semanticsLabel: 'Logo Distrito Mallos',
      fallback: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Center(
          child: Text(
            'DISTRITO\nMALLOS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (height ?? 100) * 0.15,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

class ClubCard extends StatelessWidget {
  final double? width;
  final double? height;

  const ClubCard({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    // ✅ CORREGIDO: Manejar valores infinity y null
    final cardWidth = width != null && width!.isFinite ? width : 300.0;
    final cardHeight = height != null && height!.isFinite ? height : 200.0;

    return OptimizedImage(
      assetPath: 'assets/images/tarjeta.png',
      width: cardWidth,
      height: cardHeight,
      fit: BoxFit.contain,
      semanticsLabel: 'Tarjeta Club EU MALLOS',
      fallback: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.card_membership,
                size: cardHeight! * 0.3,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                'TARJETA\nEU MALLOS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: cardHeight * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para logos institucionales
class InstitutionalLogo extends StatelessWidget {
  final String assetPath;
  final String fallbackText;
  final Color fallbackColor;
  final double? width;
  final double? height;

  const InstitutionalLogo({
    super.key,
    required this.assetPath,
    required this.fallbackText,
    required this.fallbackColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedImage(
      assetPath: assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      semanticsLabel: fallbackText,
      fallback: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: fallbackColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            fallbackText,
            style: TextStyle(
              color: Colors.white,
              fontSize: (height ?? 50) * 0.2,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}