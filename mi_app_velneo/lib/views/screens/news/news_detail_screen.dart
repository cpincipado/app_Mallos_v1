// lib/views/screens/news/news_detail_screen.dart - CON IMÁGENES ADAPTATIVAS

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/utils/image_dimensions_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/news_service.dart';
import 'package:mi_app_velneo/utils/html_text_formatter.dart';
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  NewsModel? _news;
  bool _isLoading = true;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('NewsDetailScreen: $message');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      _log('📰 Cargando noticia ID: ${widget.newsId}');
      final news = await NewsService.getNewsById(widget.newsId);

      if (mounted) {
        setState(() {
          _news = news;
          _isLoading = false;
        });
      }
    } catch (e) {
      _log('❌ Error cargando noticia: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar la noticia'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Distrito Mallos',
        showBackButton: true,
        showMenuButton: false,
        showFavoriteButton: false,
        showLogo: true,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _news == null
          ? _buildErrorState()
          : _buildNewsContent(),
    );
  }

  Widget _buildLoadingState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = ResponsiveHelper.isDesktop(context)
            ? 600.0
            : double.infinity;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
                Text(
                  'Cargando noticia...',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getBodyFontSize(context),
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = ResponsiveHelper.isDesktop(context)
            ? 600.0
            : double.infinity;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: ResponsiveHelper.getHorizontalPadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: ResponsiveHelper.getMenuButtonIconSize(context) * 2,
                    color: Colors.grey,
                  ),
                  ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
                  Text(
                    'Noticia no encontrada',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: ResponsiveHelper.getButtonHeight(context),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      child: const Text('Volver'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewsContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = ResponsiveHelper.isDesktop(context)
            ? 800.0
            : double.infinity;

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ HERO IMAGE ADAPTATIVA - SE AJUSTA AUTOMÁTICAMENTE
                  if (_news!.hasValidImage) _buildHeroImageAdaptive(),

                  // ✅ CONTENIDO UNIFICADO EN UN SOLO CONTENEDOR
                  Container(
                    width: double.infinity,
                    margin: ResponsiveHelper.getHorizontalPadding(context),
                    padding: ResponsiveHelper.getCardPadding(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getCardBorderRadius(context),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: ResponsiveHelper.getCardElevation(
                            context,
                          ),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),

                        // ✅ HEADER DE LA NOTICIA
                        _buildNewsHeader(),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.small,
                        ),

                        // ✅ TÍTULO
                        Text(
                          _news!.title,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getTitleFontSize(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            height: 1.3,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),

                        // ✅ SEPARADOR VISUAL
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey.shade200,
                        ),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),

                        // ✅ CONTENIDO
                        _buildContentText(),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),
                      ],
                    ),
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewsHeader() {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: ResponsiveHelper.getCaptionFontSize(context) + 2,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            _news!.formattedDate,
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildContentText() {
    if (!_news!.hasFullContent) {
      return Container(
        width: double.infinity,
        padding: ResponsiveHelper.getCardPadding(context),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getCardBorderRadius(context),
          ),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey.shade500,
              size: ResponsiveHelper.getMenuButtonIconSize(context),
            ),
            ResponsiveHelper.verticalSpace(context, SpacingSize.small),
            Text(
              'Contenido no disponible',
              style: TextStyle(
                fontSize: ResponsiveHelper.getBodyFontSize(context),
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    // ✅ VOLVER AL MÉTODO ORIGINAL QUE FUNCIONABA
    final cleanContent = _news!.content.newsContent;

    return Text(
      cleanContent,
      style: TextStyle(
        fontSize: ResponsiveHelper.getBodyFontSize(context),
        color: AppTheme.textPrimary,
        height: 1.6,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.justify,
      // ✅ SIN maxLines para mostrar todo el contenido
    );
  }

  /// ✅ Hero image que se adapta al aspect ratio real con mejor integración
  Widget _buildHeroImageAdaptive() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getMediumSpacing(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0), // Sin bordes para hero
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ✅ FutureBuilder para detectar dimensiones reales
            return FutureBuilder<Size>(
              future: ImageDimensionsHelper.getImageDimensions(
                _news!.imageUrl!,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Placeholder elegante mientras carga
                  return Container(
                    width: constraints.maxWidth,
                    height: ResponsiveHelper.isDesktop(context) ? 400 : 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getCardBorderRadius(context),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(strokeWidth: 2),
                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.small,
                        ),
                        Text(
                          'Cargando imagen...',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getCaptionFontSize(
                              context,
                            ),
                            color: Colors.grey.shade500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  // Fallback con altura fija
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: ResponsiveHelper.isDesktop(context)
                          ? 500
                          : 300,
                    ),
                    child: OptimizedImage.newsHero(
                      assetPath: _news!.imageUrl!,
                      borderRadius: 0,
                    ),
                  );
                }

                final imageSize = snapshot.data!;
                final imageAspectRatio = imageSize.width / imageSize.height;

                // ✅ Calcular altura basada en aspect ratio real
                final maxWidth = constraints.maxWidth;
                final calculatedHeight = maxWidth / imageAspectRatio;

                // ✅ Límites más generosos para hero images
                final minHeight = ResponsiveHelper.isMobile(context)
                    ? 200.0
                    : 250.0;
                final maxHeight = ResponsiveHelper.isMobile(context)
                    ? 500.0
                    : 600.0;

                final finalHeight = calculatedHeight.clamp(
                  minHeight,
                  maxHeight,
                );

                return Container(
                  width: maxWidth,
                  height: finalHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getCardBorderRadius(context),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: ResponsiveHelper.getCardElevation(context),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getCardBorderRadius(context),
                    ),
                    child: OptimizedImage.newsHero(
                      assetPath: _news!.imageUrl!,
                      borderRadius: 0, // Ya tiene ClipRRect
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
