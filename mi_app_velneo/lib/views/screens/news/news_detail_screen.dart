// lib/views/screens/news/news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/news_service.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  NewsModel? _news;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final news = await NewsService.getNewsById(widget.newsId);
      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
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
        showLogo: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _news == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
                    color: Colors.grey,
                  ),
                  ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
                  Text(
                    'Noticia no encontrada',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen principal (si existe)
                  if (_news!.imageUrl != null) _buildHeroImage(),

                  // Contenido de la noticia
                  Padding(
                    padding: ResponsiveHelper.getHorizontalPadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.large,
                        ),

                        // Fecha
                        Text(
                          _news!.formattedDate,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getCaptionFontSize(
                              context,
                            ),
                            color: Colors.grey.shade600,
                          ),
                        ),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),

                        // Título
                        Text(
                          _news!.title,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getTitleFontSize(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            height: 1.2,
                          ),
                        ),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.large,
                        ),

                        // Contenido
                        Text(
                          _news!.content,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getBodyFontSize(context),
                            color: AppTheme.textPrimary,
                            height: 1.6,
                          ),
                        ),

                        ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                        // Categoría (si existe)
                        if (_news!.category != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.getMediumSpacing(
                                context,
                              ),
                              vertical: ResponsiveHelper.getSmallSpacing(
                                context,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _news!.category!,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getCaptionFontSize(
                                  context,
                                ),
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: ResponsiveHelper.getScreenHeight(context) * 0.4,
        minHeight: ResponsiveHelper.getContainerMinHeight(context) * 1.5,
      ),
      child: Stack(
        children: [
          // Imagen principal
          Positioned.fill(
            child: Image.asset(
              _news!.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // Gradiente inferior para mejorar legibilidad
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
