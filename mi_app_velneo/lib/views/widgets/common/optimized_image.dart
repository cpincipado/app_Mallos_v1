// lib/views/widgets/common/optimized_image.dart - VERSIÓN EXTENDIDA CON ADAPTACIÓN AUTOMÁTICA

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/utils/image_dimensions_helper.dart';

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
  final bool fastMode; // Modo rápido para noticias
  final bool isAdaptive; // ✅ NUEVO: Modo adaptativo

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
    this.isAdaptive = false, // ✅ NUEVO
  });

  /// ✅ NUEVO: Constructor adaptativo que se ajusta automáticamente
  const OptimizedImage.adaptive({
    super.key,
    required this.assetPath,
    this.borderRadius = 12.0,
    this.showBorder = false,
    this.borderColor,
    this.boxShadow,
    this.errorMessage = 'Error al cargar imagen',
    this.semanticsLabel,
  }) : width = null,
       height = null,
       fit = BoxFit.contain, // Mostrar imagen completa
       fallback = null,
       enableCache = true,
       aspectRatio = null, // Se calculará automáticamente
       fastMode = false,
       isAdaptive = true; // ✅ MODO ADAPTATIVO ACTIVADO

  /// ✅ NUEVO: Constructor para noticias adaptativas SIN RECORTAR
  const OptimizedImage.newsAdaptive({
    super.key,
    required this.assetPath,
    this.borderRadius = 12.0,
    this.showBorder = false,
    this.borderColor,
    this.boxShadow,
    this.errorMessage = 'Error al cargar imagen de noticia',
  }) : width = null,
       height = null,
       fit = BoxFit
           .contain, // ✅ CONTAIN para mostrar imagen completa sin recortar
       fallback = null,
       semanticsLabel = 'Imagen de noticia',
       enableCache = false, // Modo rápido
       aspectRatio = null,
       fastMode = true,
       isAdaptive = true; // ✅ MODO ADAPTATIVO ACTIVADO

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
       fit = BoxFit.cover, // En cards sí puede recortar para uniformidad
       fallback = null,
       semanticsLabel = null,
       enableCache = false, // Modo rápido sin cache
       aspectRatio = 16 / 9, // Aspect ratio fijo para uniformidad en listados
       fastMode = true,
       isAdaptive = false; // Cards no son adaptativos para mantener uniformidad

  /// ✅ Constructor para hero images de noticias (adaptativo)
  const OptimizedImage.newsHero({
    super.key,
    required this.assetPath,
    this.borderRadius = 0.0,
    this.errorMessage = 'Error al cargar imagen',
  }) : width = null,
       height = null,
       fit = BoxFit.contain, // Mostrar imagen completa
       fallback = null,
       semanticsLabel = 'Imagen principal de noticia',
       enableCache = false, // Modo rápido
       showBorder = false,
       borderColor = null,
       boxShadow = null,
       aspectRatio = null, // Se adaptará automáticamente
       fastMode = true,
       isAdaptive = true; // ✅ MODO ADAPTATIVO ACTIVADO

  /// ✅ Constructor para sección home de noticias (MANTENER IGUAL)
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
       fit = BoxFit.contain, // CONTAIN para mostrar imagen completa
       fallback = null,
       semanticsLabel = null,
       enableCache = false, // Modo rápido sin cache
       aspectRatio = null, // SIN aspect ratio fijo - se adapta a la imagen
       fastMode = true,
       isAdaptive = false; // Home ya tiene su propia lógica

  @override
  Widget build(BuildContext context) {
    // ✅ SI ES ADAPTATIVO, usar FutureBuilder para detectar dimensiones
    if (isAdaptive) {
      return _buildAdaptiveImage(context);
    }

    // ✅ COMPORTAMIENTO ORIGINAL para no romper código existente
    return _buildStaticImage(context);
  }

  /// ✅ NUEVO: Widget adaptativo que detecta dimensiones automáticamente
  Widget _buildAdaptiveImage(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder<Size>(
          future: ImageDimensionsHelper.getImageDimensions(assetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingPlaceholder(context, constraints);
            }

            if (snapshot.hasError || !snapshot.hasData) {
              if (kDebugMode) {
                debugPrint('❌ Error obteniendo dimensiones: ${snapshot.error}');
              }
              return _buildErrorWidget(context, constraints);
            }

            final imageSize = snapshot.data!;
            return _buildAdaptiveContainer(context, constraints, imageSize);
          },
        );
      },
    );
  }

  /// ✅ NUEVO: Construir contenedor adaptativo basado en dimensiones reales
  Widget _buildAdaptiveContainer(
    BuildContext context,
    BoxConstraints constraints,
    Size imageSize,
  ) {
    // ✅ OBTENER LÍMITES DESDE ResponsiveHelper
    final maxConstraints = Size(
      ResponsiveHelper.getMaxImageWidth(context),
      ResponsiveHelper.getMaxImageHeight(context),
    );

    final minConstraints = Size(
      ResponsiveHelper.getMinImageWidth(context),
      ResponsiveHelper.getMinImageHeight(context),
    );

    // ✅ CALCULAR DIMENSIONES ADAPTATIVAS
    final adaptiveSize = ImageDimensionsHelper.calculateAdaptiveContainerSize(
      imageSize: imageSize,
      maxConstraints: maxConstraints,
      minConstraints: minConstraints,
    );

    // ✅ APLICAR CONSTRAINTS DEL PARENT si son más restrictivos
    final finalWidth = constraints.maxWidth.isFinite
        ? (adaptiveSize.width > constraints.maxWidth
              ? constraints.maxWidth
              : adaptiveSize.width)
        : adaptiveSize.width;

    final finalHeight = constraints.maxHeight.isFinite
        ? (adaptiveSize.height > constraints.maxHeight
              ? constraints.maxHeight
              : adaptiveSize.height)
        : adaptiveSize.height;

    Widget imageWidget = _buildImageWidget(
      context,
      width: finalWidth,
      height: finalHeight,
    );

    // ✅ APLICAR DECORACIÓN DEL CONTENEDOR si es necesario
    if (showBorder || boxShadow != null || borderRadius > 0) {
      imageWidget = Container(
        width: finalWidth,
        height: finalHeight,
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

  /// ✅ COMPORTAMIENTO ORIGINAL para compatibilidad
  Widget _buildStaticImage(BuildContext context) {
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
  Widget _buildImageWidget(
    BuildContext context, {
    double? width,
    double? height,
  }) {
    final finalWidth = width ?? (aspectRatio != null ? null : this.width);
    final finalHeight = height ?? (aspectRatio != null ? null : this.height);

    // ✅ Determinar si es URL remota o asset local
    final isNetworkImage =
        assetPath.startsWith('http://') || assetPath.startsWith('https://');

    if (isNetworkImage) {
      return fastMode
          ? _buildFastNetworkImage(context, finalWidth, finalHeight)
          : _buildCachedNetworkImage(context, finalWidth, finalHeight);
    } else {
      return _buildAssetImage(context, finalWidth, finalHeight);
    }
  }

  /// ✅ MODO RÁPIDO: Image.network directo (para noticias)
  Widget _buildFastNetworkImage(
    BuildContext context,
    double? width,
    double? height,
  ) {
    return Image.network(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      // ✅ SIN loadingBuilder para máxima velocidad
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          debugPrint('❌ Error loading fast network image: $assetPath - $error');
        }
        return _buildErrorWidgetStatic(context, width, height);
      },
    );
  }

  /// ✅ MODO CON CACHE: CachedNetworkImage (para logos, cards reutilizables)
  Widget _buildCachedNetworkImage(
    BuildContext context,
    double? width,
    double? height,
  ) {
    return CachedNetworkImage(
      imageUrl: assetPath,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          _buildLoadingWidgetStatic(context, width, height),
      errorWidget: (context, url, error) {
        if (kDebugMode) {
          debugPrint(
            '❌ Error loading cached network image: $assetPath - $error',
          );
        }
        return fallback ?? _buildErrorWidgetStatic(context, width, height);
      },
      memCacheWidth: enableCache ? _getCacheWidth(context, width) : null,
      memCacheHeight: enableCache ? _getCacheHeight(context, height) : null,
    );
  }

  /// ✅ Widget para assets locales
  Widget _buildAssetImage(BuildContext context, double? width, double? height) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticsLabel,
      cacheWidth: enableCache ? _getCacheWidth(context, width) : null,
      cacheHeight: enableCache ? _getCacheHeight(context, height) : null,
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          debugPrint('❌ Error loading asset image: $assetPath - $error');
        }
        return fallback ?? _buildErrorWidgetStatic(context, width, height);
      },
    );
  }

  /// ✅ NUEVO: Loading placeholder para modo adaptativo
  Widget _buildLoadingPlaceholder(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final maxWidth = ResponsiveHelper.getMaxImageWidth(context);
    final maxHeight = ResponsiveHelper.getMaxImageHeight(context);

    return Container(
      width: constraints.maxWidth.isFinite
          ? (constraints.maxWidth > maxWidth ? maxWidth : constraints.maxWidth)
          : maxWidth,
      height: constraints.maxHeight.isFinite
          ? (constraints.maxHeight > maxHeight
                ? maxHeight
                : constraints.maxHeight)
          : maxHeight,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey.shade400,
              ),
            ),
            ResponsiveHelper.verticalSpace(context, SpacingSize.small),
            Text(
              'Cargando imagen...',
              style: TextStyle(
                fontSize: ResponsiveHelper.getCaptionFontSize(context),
                color: Colors.grey.shade500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Placeholder mientras carga la imagen (modo estático)
  Widget _buildLoadingWidgetStatic(
    BuildContext context,
    double? width,
    double? height,
  ) {
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

  /// ✅ NUEVO: Error widget para modo adaptativo
  Widget _buildErrorWidget(BuildContext context, BoxConstraints constraints) {
    final maxWidth = ResponsiveHelper.getMaxImageWidth(context);
    final maxHeight = ResponsiveHelper.getMaxImageHeight(context);

    return Container(
      width: constraints.maxWidth.isFinite
          ? (constraints.maxWidth > maxWidth ? maxWidth : constraints.maxWidth)
          : maxWidth,
      height: constraints.maxHeight.isFinite
          ? (constraints.maxHeight > maxHeight
                ? maxHeight
                : constraints.maxHeight)
          : maxHeight,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: ResponsiveHelper.getMenuButtonIconSize(context),
            color: Colors.red.shade400,
          ),
          if (errorMessage != null && errorMessage!.isNotEmpty) ...[
            ResponsiveHelper.verticalSpace(context, SpacingSize.small),
            Padding(
              padding: ResponsiveHelper.getHorizontalPadding(context),
              child: Text(
                errorMessage!,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  color: Colors.red.shade600,
                ),
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

  /// ✅ ERROR WIDGET ESTÁTICO (original)
  Widget _buildErrorWidgetStatic(
    BuildContext context,
    double? width,
    double? height,
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
            Icons.image_not_supported_outlined,
            size: _calculateIconSize(width, height),
            color: Colors.red.shade400,
          ),
          if (errorMessage != null && errorMessage!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                errorMessage!,
                style: TextStyle(fontSize: 12.0, color: Colors.red.shade600),
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
  int? _getCacheWidth(BuildContext context, double? width) {
    if (width == null) return null;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return (width * devicePixelRatio).round();
  }

  int? _getCacheHeight(BuildContext context, double? height) {
    if (height == null) return null;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return (height * devicePixelRatio).round();
  }

  double _calculateIconSize([double? width, double? height]) {
    if (width != null && height != null) {
      return (width < height ? width * 0.3 : height * 0.3);
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
    final cardWidth = width != null && width!.isFinite ? width! : 300.0;
    final cardHeight = height != null && height!.isFinite ? height! : 200.0;

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
                size: cardHeight * 0.3,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
  /// ✅ NUEVO: Crea una imagen adaptativa que se ajusta automáticamente
  Widget asAdaptiveImage({
    double borderRadius = 12.0,
    bool showBorder = false,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
    String? errorMessage,
  }) {
    return OptimizedImage.adaptive(
      assetPath: this,
      borderRadius: borderRadius,
      showBorder: showBorder,
      borderColor: borderColor,
      boxShadow: boxShadow,
      errorMessage: errorMessage,
    );
  }

  /// ✅ NUEVO: Crea una imagen de noticia adaptativa
  Widget asNewsAdaptiveImage({
    double borderRadius = 12.0,
    bool showBorder = false,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
  }) {
    return OptimizedImage.newsAdaptive(
      assetPath: this,
      borderRadius: borderRadius,
      showBorder: showBorder,
      borderColor: borderColor,
      boxShadow: boxShadow,
    );
  }

  /// ✅ NUEVO: Crea una hero image adaptativa para noticias
  Widget asNewsHeroAdaptive({double borderRadius = 0.0}) {
    return OptimizedImage.newsHero(assetPath: this, borderRadius: borderRadius);
  }

  /// Crea una imagen optimizada para cards de noticias (EXISTENTE)
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

  /// Crea una imagen optimizada para la sección home (MANTENER IGUAL)
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
