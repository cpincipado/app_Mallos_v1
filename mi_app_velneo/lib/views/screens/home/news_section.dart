// lib/views/screens/home/news_section.dart - VERSIÓN EXPANDIBLE
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
  NewsModel? _latestNews;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLatestNews();
  }

  Future<void> _loadLatestNews() async {
    try {
      final news = await NewsService.getAllNews();
      if (news.isNotEmpty) {
        setState(() {
          _latestNews = news.first; // Mostrar la noticia más reciente
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToNews() {
    if (_latestNews != null) {
      // ✅ IR DIRECTAMENTE A LA NOTICIA ESPECÍFICA
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(newsId: _latestNews!.id),
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
          // ✅ NUEVO: Usar TODA la altura disponible
          final availableHeight = constraints.maxHeight;

          return Container(
            width: double.infinity,
            height: availableHeight, // ✅ USAR TODA LA ALTURA DISPONIBLE
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
                : _latestNews != null
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
            'No hay noticias disponibles',
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

  // ✅ PREVIEW DE LA NOTICIA - NUEVA VERSIÓN CON SCROLL INTERNO
  Widget _buildNewsPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.getCardBorderRadius(context),
      ),
      child: _latestNews!.imageUrl != null
          ? _buildNewsWithImage()
          : _buildNewsWithoutImage(),
    );
  }

  // ✅ NOTICIA CON IMAGEN - SOLO IMAGEN Y TÍTULO
  Widget _buildNewsWithImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ✅ ALTURA DISPONIBLE para contenido
        final availableHeight = constraints.maxHeight;

        return Column(
          children: [
            // ✅ IMAGEN - OCUPA 80% DE LA ALTURA DISPONIBLE
            SizedBox(
              height: availableHeight * 0.8,
              width: double.infinity,
              child: Image.asset(
                _latestNews!.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImagePlaceholder(availableHeight * 0.8),
              ),
            ),

            // ✅ TÍTULO - OCUPA 20% RESTANTE
            Expanded(
              child: Container(
                width: double.infinity,
                padding: ResponsiveHelper.getCardPadding(context),
                child: Center(
                  child: Text(
                    _latestNews!.title,
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
            _latestNews!.title,
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
            Icons.newspaper,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.2,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'Última Noticia',
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _latestNews?.title ?? 'Sin noticias',
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
