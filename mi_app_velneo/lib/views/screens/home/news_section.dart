// lib/views/screens/home/news_section.dart - OPTIMIZADA PARA HOME
import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/news_service.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/views/screens/news/news_detail_screen.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  NewsModel? _homeNews;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeNews();
  }

  /// ✅ OPTIMIZADO: Cargar solo noticias para HOME (port: true)
  Future<void> _loadHomeNews() async {
    try {
      print('🏠 Cargando noticia para HOME...');
      
      // ✅ Usar método optimizado para HOME
      final homeNewsList = await NewsService.getHomeNews();
      
      if (homeNewsList.isNotEmpty) {
        setState(() {
          _homeNews = homeNewsList.first; // La primera noticia con port:true
          _isLoading = false;
        });
        print('✅ Noticia HOME cargada: ${_homeNews!.title}');
      } else {
        setState(() {
          _isLoading = false;
        });
        print('⚠️ No hay noticias con port:true');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('❌ Error cargando noticia HOME: $e');
    }
  }

  void _navigateToNews() {
    if (_homeNews != null) {
      // ✅ IR DIRECTAMENTE A LA NOTICIA ESPECÍFICA
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(newsId: _homeNews!.id),
        ),
      );
    } else {
      // Si no hay noticia específica, ir a la lista
      AppRoutes.navigateToNews(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToNews,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;

          return Container(
            width: double.infinity,
            height: availableHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getCardBorderRadius(context),
              ),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: ResponsiveHelper.getCardElevation(context),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isLoading
                ? _buildLoadingState()
                : _homeNews != null
                ? _buildNewsPreview()
                : _buildEmptyState(),
          );
        },
      ),
    );
  }

  // ✅ ESTADO DE CARGA
  Widget _buildLoadingState() {
    return Padding(
      padding: ResponsiveHelper.getCardPadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
          Text(
            'Cargando noticias...',
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ESTADO VACÍO
  Widget _buildEmptyState() {
    return Padding(
      padding: ResponsiveHelper.getCardPadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
            color: Colors.grey,
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
          Text(
            'Última Noticia',
            style: TextStyle(
              fontSize: ResponsiveHelper.getHeadingFontSize(context),
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.small),
          Text(
            'No hay noticias destacadas',
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ✅ PREVIEW DE LA NOTICIA OPTIMIZADA
  Widget _buildNewsPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.getCardBorderRadius(context),
      ),
      child: _homeNews!.hasValidImage
          ? _buildNewsWithImage()
          : _buildNewsWithoutImage(),
    );
  }

  // ✅ NOTICIA CON IMAGEN - ARREGLADA PARA MOSTRAR IMÁGENES DE URL
  Widget _buildNewsWithImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;

        return Column(
          children: [
            // ✅ IMAGEN - OCUPA 70% DE LA ALTURA DISPONIBLE
            SizedBox(
              height: availableHeight * 0.7,
              width: double.infinity,
              child: _buildOptimizedImage(availableHeight * 0.7),
            ),

            // ✅ TÍTULO - OCUPA 30% RESTANTE
            Expanded(
              child: Container(
                width: double.infinity,
                padding: ResponsiveHelper.getCardPadding(context),
                child: Center(
                  child: Text(
                    _homeNews!.title,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getHeadingFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ✅ NOTICIA SIN IMAGEN - SOLO TÍTULO CENTRADO
  Widget _buildNewsWithoutImage() {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getCardPadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono de noticia
          Icon(
            Icons.newspaper,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
            color: AppTheme.primaryColor,
          ),

          ResponsiveHelper.verticalSpace(context, SpacingSize.large),

          // Título
          Text(
            _homeNews!.title,
            style: TextStyle(
              fontSize: ResponsiveHelper.getHeadingFontSize(context),
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ✅ IMAGEN OPTIMIZADA - MANEJA URLs Y ASSETS
  Widget _buildOptimizedImage(double height) {
    final imageUrl = _homeNews!.imageUrl!;
    
    // ✅ Si es una URL (como la de tu API)
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImageLoading(height);
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error cargando imagen: $imageUrl');
          return _buildImagePlaceholder(height);
        },
      );
    }
    
    // ✅ Si es un asset local
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error cargando asset: $imageUrl');
          return _buildImagePlaceholder(height);
        },
      );
    }
    
    // ✅ Si no es reconocido, mostrar placeholder
    return _buildImagePlaceholder(height);
  }

  // ✅ LOADING MIENTRAS CARGA LA IMAGEN
  Widget _buildImageLoading(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            'Cargando imagen...',
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ PLACEHOLDER PARA IMAGEN
  Widget _buildImagePlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.2,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'Sin imagen',
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _homeNews?.title ?? 'Noticia',
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}