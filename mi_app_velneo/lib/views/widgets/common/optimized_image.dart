// lib/views/widgets/common/optimized_image.dart - VERSIÓN UNIFICADA EXTENDIDA

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
  final double borderRadius;
  final bool showBorder;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final double? aspectRatio;
  final String? errorMessage;
  final bool fastMode; // ✅ NUEVO: Modo rápido para noticias

  const OptimizedImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallback,
    this.semanticsLabel,
    this.enableCache = true,
    this.borderRadius = 0.0,
    this.showBorder = false,
    this.borderColor,
    this.boxShadow,
    this.aspectRatio,
    this.errorMessage,
    this.fastMode = false,
  });

  /// ✅ Constructor para cards de noticias (modo rápido + aspect ratio)
  const OptimizedImage.newsCard({
    super.key,
    required this.assetPath,
    this.borderRadius = 12.0,
    this.showBorder = false,
    this.borderColor,
    this.boxShadow,
    this.errorMessage = 'Error al cargar imagen',
  }) : width = null,
       height = null,
       fit = BoxFit.cover,
       fallback = null,
       semanticsLabel = null,
       enableCache = false, // ✅ Modo rápido sin cache
       aspectRatio = 16 / 9,
       fastMode = true;

  /// ✅ Constructor para hero images de noticias (modo rápido)
  const OptimizedImage.newsHero({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.borderRadius = 0.0,
    this.errorMessage = 'Error al cargar imagen',
  }) : fit = BoxFit.cover,
       fallback = null,
       semanticsLabel = null,
       enableCache = false, // ✅ Modo rápido sin cache
       showBorder = false,
       borderColor = null,
       boxShadow = null,
       aspectRatio = null,
       fastMode = true;

  /// ✅ Constructor para sección home de noticias (modo rápido + imagen completa)
  const OptimizedImage.newsHomeSection({
    super.key,
    required this.assetPath,
    this.borderRadius = 12.0,
    this.showBorder = true,
    this.borderColor,
    this.boxShadow,
    this.errorMessage = 'Error al cargar imagen',
  }) : width = null,
       height = null,
       fit = BoxFit
           .contain, // ✅ CONTAIN para mostrar imagen completa sin recortar
       fallback = null,
       semanticsLabel = null,
       enableCache = false, // ✅ Modo rápido sin cache
       aspectRatio = null, // ✅ SIN aspect ratio fijo - se adapta a la imagen
       fastMode = true;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageWidget(context);

    // ✅ Aplicar AspectRatio si se especifica
    if (aspectRatio != null) {
      imageWidget = AspectRatio(aspectRatio: aspectRatio!, child: imageWidget);
    }

    // ✅ Aplicar decoración del contenedor si es necesario
    if (showBorder || boxShadow != null || borderRadius > 0) {
      imageWidget = Container(
        width: aspectRatio != null ? null : width,
        height: aspectRatio != null ? null : height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: showBorder
              ? Border.all(
                  color: borderColor ?? Colors.grey.shade300,
                  width: 2.0,
                )
              : null,
          boxShadow: boxShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: imageWidget,
        ),
      );
    }

    return imageWidget;
  }

  /// ✅ LÓGICA UNIFICADA DE CONSTRUCCIÓN DE IMAGEN
  Widget _buildImageWidget(BuildContext context) {
    // ✅ Determinar si es URL remota o asset local
    final isNetworkImage =
        assetPath.startsWith('http://') || assetPath.startsWith('https://');

    if (isNetworkImage) {
      return fastMode
          ? _buildFastNetworkImage(context)
          : _buildCachedNetworkImage(context);
    } else {
      return _buildAssetImage(context);
    }
  }

  /// ✅ MODO RÁPIDO: Image.network directo (para noticias)
  Widget _buildFastNetworkImage(BuildContext context) {
    return Image.network(
      assetPath,
      width: aspectRatio != null ? null : width,
      height: aspectRatio != null ? null : height,
      fit: fit,
      // ✅ SIN loadingBuilder para máxima velocidad
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Error loading fast network image: $assetPath - $error');
        return _buildErrorWidget(context);
      },
    );
  }

  /// ✅ MODO CON CACHE: CachedNetworkImage (para logos, cards reutilizables)
  Widget _buildCachedNetworkImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: assetPath,
      width: aspectRatio != null ? null : width,
      height: aspectRatio != null ? null : height,
      fit: fit,
      placeholder: (context, url) => _buildLoadingPlaceholder(context),
      errorWidget: (context, url, error) {
        debugPrint('❌ Error loading cached network image: $assetPath - $error');
        return fallback ?? _buildErrorWidget(context);
      },
      memCacheWidth: enableCache ? _getCacheWidth(context) : null,
      memCacheHeight: enableCache ? _getCacheHeight(context) : null,
    );
  }

  /// ✅ Widget para assets locales (sin cambios)
  Widget _buildAssetImage(BuildContext context) {
    return Image.asset(
      assetPath,
      width: aspectRatio != null ? null : width,
      height: aspectRatio != null ? null : height,
      fit: fit,
      semanticLabel: semanticsLabel,
      cacheWidth: enableCache ? _getCacheWidth(context) : null,
      cacheHeight: enableCache ? _getCacheHeight(context) : null,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Error loading asset image: $assetPath - $error');
        return fallback ?? _buildErrorWidget(context);
      },
    );
  }

  /// ✅ Placeholder mientras carga la imagen (solo modo con cache)
  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      width: aspectRatio != null ? null : width,
      height: aspectRatio != null ? null : height,
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

  /// ✅ ERROR WIDGET UNIFICADO
  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: aspectRatio != null ? null : width,
      height: aspectRatio != null ? null : height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: _calculateIconSize(),
            color: Colors.grey.shade400,
          ),
          if (errorMessage != null && errorMessage!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                errorMessage!,
                style: TextStyle(fontSize: 12.0, color: Colors.grey.shade500),
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

  // ✅ MÉTODOS HELPER (sin cambios)
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

  double _calculateIconSize() {
    if (width != null && height != null) {
      return (width! < height! ? width! * 0.3 : height! * 0.3);
    }
    return 28;
  }
}

// ===============================================
// WIDGETS ESPECÍFICOS EXISTENTES (SIN CAMBIOS)
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
      enableCache: true, // ✅ Los logos SÍ usan cache
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
    final cardWidth = width != null && width!.isFinite ? width : 300.0;
    final cardHeight = height != null && height!.isFinite ? height : 200.0;

    return OptimizedImage(
      assetPath: 'assets/images/tarjeta.png',
      width: cardWidth,
      height: cardHeight,
      fit: BoxFit.contain,
      semanticsLabel: 'Tarjeta Club EU MALLOS',
      enableCache: true, // ✅ Las tarjetas SÍ usan cache
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
      enableCache: true, // ✅ Los logos institucionales SÍ usan cache
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

// ===============================================
// ✅ EXTENSIONES PARA FACILITAR EL USO
// ===============================================

extension StringImageExtensions on String {
  /// Crea una imagen optimizada para cards de noticias
  Widget asNewsCardImage({
    double borderRadius = 12.0,
    bool showBorder = false,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
  }) {
    return OptimizedImage.newsCard(
      assetPath: this,
      borderRadius: borderRadius,
      showBorder: showBorder,
      borderColor: borderColor,
      boxShadow: boxShadow,
    );
  }

  /// Crea una imagen optimizada para hero images de noticias
  Widget asNewsHeroImage({
    double? width,
    double? height,
    double borderRadius = 0.0,
  }) {
    return OptimizedImage.newsHero(
      assetPath: this,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  /// Crea una imagen optimizada para la sección home (imagen completa sin recortar)
  Widget asNewsHomeSectionImage({
    double borderRadius = 12.0,
    bool showBorder = true,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
  }) {
    return OptimizedImage.newsHomeSection(
      assetPath: this,
      borderRadius: borderRadius,
      showBorder: showBorder,
      borderColor: borderColor,
      boxShadow: boxShadow,
    );
  }
}
