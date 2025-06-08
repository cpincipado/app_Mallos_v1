// lib/views/screens/home/news_section.dart
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
      child: Padding(
        padding: ResponsiveHelper.getHorizontalPadding(context),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: ResponsiveHelper.getContainerMinHeight(context) * 0.8,
            maxHeight:
                ResponsiveHelper.getContainerMinHeight(context) *
                1.5, // ✅ Aumentado de 1.2 a 1.5
          ),
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
        ),
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

  // ✅ PREVIEW DE LA NOTICIA - SOLO IMAGEN
  Widget _buildNewsPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.getCardBorderRadius(context),
      ),
      child: _latestNews!.imageUrl != null
          ? Image.asset(
              _latestNews!.imageUrl!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildImagePlaceholder(),
            )
          : _buildImagePlaceholder(),
    );
  }

  // ✅ PLACEHOLDER PARA IMAGEN
  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
