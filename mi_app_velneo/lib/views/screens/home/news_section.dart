// lib/views/screens/home/news_section.dart - ULTRA OPTIMIZADA COMPLETA

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

  // ✅ CACHE SIZES CALCULADOS UNA SOLA VEZ
  late final double _cardRadius;
  late final double _cardElevation;
  late final EdgeInsets _cardPadding;
  late final double _iconSize;
  late final double _headingFontSize;
  late final double _captionFontSize;
  late final double _verticalSpaceMedium;
  late final double _verticalSpaceLarge;

  /// ✅ LOGGING CONDICIONAL
  void _log(String message) {
    if (kDebugMode) {
      print('NewsSection: $message');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHomeNews();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ CALCULAR TAMAÑOS UNA SOLA VEZ
    _calculateSizes();
  }

  /// ✅ PRE-CALCULAR TODOS LOS TAMAÑOS
  void _calculateSizes() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    // ✅ TAMAÑOS OPTIMIZADOS SEGÚN DISPOSITIVO
    if (isMobile) {
      _cardRadius = 12.0;
      _cardElevation = 4.0;
      _cardPadding = const EdgeInsets.all(16.0);
      _iconSize = 28.0;
      _headingFontSize = 16.0;
      _captionFontSize = 12.0;
      _verticalSpaceMedium = 12.0;
      _verticalSpaceLarge = 16.0;
    } else if (isTablet) {
      _cardRadius = 14.0;
      _cardElevation = 5.0;
      _cardPadding = const EdgeInsets.all(18.0);
      _iconSize = 30.0;
      _headingFontSize = 18.0;
      _captionFontSize = 13.0;
      _verticalSpaceMedium = 14.0;
      _verticalSpaceLarge = 18.0;
    } else {
      _cardRadius = 16.0;
      _cardElevation = 6.0;
      _cardPadding = const EdgeInsets.all(20.0);
      _iconSize = 32.0;
      _headingFontSize = 20.0;
      _captionFontSize = 14.0;
      _verticalSpaceMedium = 16.0;
      _verticalSpaceLarge = 20.0;
    }
  }

  /// ✅ CARGA OPTIMIZADA DE NOTICIAS
  Future<void> _loadHomeNews() async {
    try {
      _log('📰 Iniciando carga HOME news...');
      final startTime = DateTime.now();

      final homeNewsList = await NewsService.getHomeNews();

      final loadTime = DateTime.now().difference(startTime).inMilliseconds;
      _log('⚡ HOME news cargadas en ${loadTime}ms');

      if (mounted) {
        setState(() {
          _homeNews = homeNewsList.isNotEmpty ? homeNewsList.first : null;
          _isLoading = false;
        });

        if (_homeNews != null) {
          _log('✅ Noticia mostrada: ${_homeNews!.title}');
        } else {
          _log('⚠️ No hay noticias destacadas');
        }
      }
    } catch (e) {
      _log('❌ Error cargando HOME news: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToNews() {
    if (!mounted) return;

    if (_homeNews != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(newsId: _homeNews!.id),
        ),
      );
    } else {
      AppRoutes.navigateToNews(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToNews,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_cardRadius),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: _cardElevation,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_cardRadius),
              child: _buildContent(constraints.maxHeight),
            ),
          );
        },
      ),
    );
  }

  /// ✅ CONTENIDO OPTIMIZADO
  Widget _buildContent(double availableHeight) {
    if (_isLoading) return _buildLoadingState();
    if (_homeNews == null) return _buildEmptyState();

    return _homeNews!.hasValidImage
        ? _buildNewsWithImage(availableHeight)
        : _buildNewsWithoutImage();
  }

  /// ✅ LOADING STATE SIMPLE
  Widget _buildLoadingState() {
    return Padding(
      padding: _cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.primaryColor,
          ),
          SizedBox(height: _verticalSpaceMedium),
          Text(
            'Cargando noticias...',
            style: TextStyle(fontSize: _captionFontSize, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// ✅ EMPTY STATE SIMPLE
  Widget _buildEmptyState() {
    return Padding(
      padding: _cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: _iconSize * 1.5, color: Colors.grey),
          SizedBox(height: _verticalSpaceMedium),
          Text(
            'Última Noticia',
            style: TextStyle(
              fontSize: _headingFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _verticalSpaceMedium * 0.5),
          Text(
            'No hay noticias destacadas',
            style: TextStyle(
              fontSize: _captionFontSize,
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

  /// ✅ NOTICIA CON IMAGEN - OPTIMIZADA
  Widget _buildNewsWithImage(double availableHeight) {
    final imageHeight = availableHeight * 0.7;

    return Column(
      children: [
        // ✅ IMAGEN OPTIMIZADA
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: _buildFastImage(imageHeight),
        ),

        // ✅ TÍTULO - OCUPA 30% RESTANTE CON PADDING PRE-CALCULADO
        Expanded(
          child: Container(
            width: double.infinity,
            padding: _cardPadding,
            child: Center(
              child: Text(
                _homeNews!.title,
                style: TextStyle(
                  fontSize: _headingFontSize,
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
  }

  /// ✅ NOTICIA SIN IMAGEN - OPTIMIZADA CON TAMAÑOS PRE-CALCULADOS
  Widget _buildNewsWithoutImage() {
    return Container(
      width: double.infinity,
      padding: _cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono con tamaño pre-calculado
          Icon(
            Icons.newspaper,
            size: _iconSize * 1.5,
            color: AppTheme.primaryColor,
          ),

          SizedBox(height: _verticalSpaceLarge),

          // Título con tamaño pre-calculado
          Text(
            _homeNews!.title,
            style: TextStyle(
              fontSize: _headingFontSize,
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

  /// ✅ IMAGEN ULTRA OPTIMIZADA - SIN CachedNetworkImage
  Widget _buildFastImage(double height) {
    final imageUrl = _homeNews!.imageUrl!;

    // ✅ URL remota - Image.network directo (más rápido)
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        // ✅ SIN loadingBuilder para máxima velocidad
        errorBuilder: (context, error, stackTrace) {
          _log('Error imagen: $imageUrl');
          return _buildFastPlaceholder(height);
        },
      );
    }

    // ✅ Asset local - directo
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          _log('Error asset: $imageUrl');
          return _buildFastPlaceholder(height);
        },
      );
    }

    // ✅ URL inválida
    return _buildFastPlaceholder(height);
  }

  /// ✅ PLACEHOLDER ULTRA RÁPIDO - TAMAÑOS PRE-CALCULADOS
  Widget _buildFastPlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: _iconSize * 1.2,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: _verticalSpaceMedium * 0.5),
          Text(
            'Sin imagen',
            style: TextStyle(
              fontSize: _captionFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: _verticalSpaceMedium * 0.25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _homeNews?.title ?? 'Noticia',
              style: TextStyle(
                fontSize: _captionFontSize * 0.9,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
