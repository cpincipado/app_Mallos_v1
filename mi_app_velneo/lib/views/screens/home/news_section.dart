// lib/views/screens/home/news_section.dart - USANDO OptimizedImage UNIFICADO

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/news_service.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/views/screens/news/news_detail_screen.dart';
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  NewsModel? _homeNews;
  bool _isLoading = true;

  // ✅ DIMENSIONES MÁXIMAS PARA LA IMAGEN
  static const double _maxImageWidth = 600.0;
  static const double _maxImageHeight = 400.0;
  static const double _minImageHeight = 200.0;

  // ✅ CACHE SIZES CALCULADOS UNA SOLA VEZ
  late final double _cardRadius;
  late final double _cardElevation;
  late final EdgeInsets _cardPadding;
  late final double _iconSize;
  late final double _captionFontSize;
  late final double _verticalSpaceMedium;

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
      _captionFontSize = 12.0;
      _verticalSpaceMedium = 12.0;
    } else if (isTablet) {
      _cardRadius = 14.0;
      _cardElevation = 5.0;
      _cardPadding = const EdgeInsets.all(18.0);
      _iconSize = 30.0;
      _captionFontSize = 13.0;
      _verticalSpaceMedium = 14.0;
    } else {
      _cardRadius = 16.0;
      _cardElevation = 6.0;
      _cardPadding = const EdgeInsets.all(20.0);
      _iconSize = 32.0;
      _captionFontSize = 14.0;
      _verticalSpaceMedium = 16.0;
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
          return Center(child: _buildContent(constraints));
        },
      ),
    );
  }

  /// ✅ CONTENIDO OPTIMIZADO - CONTENEDOR ADAPTATIVO
  Widget _buildContent(BoxConstraints constraints) {
    if (_isLoading) return _buildLoadingState(constraints);
    if (_homeNews == null) return _buildEmptyState(constraints);

    return _homeNews!.hasValidImage
        ? _buildAdaptiveImageContainer(constraints)
        : _buildNoImageState(constraints);
  }

  /// ✅ LOADING STATE ADAPTATIVO
  Widget _buildLoadingState(BoxConstraints constraints) {
    final containerWidth = constraints.maxWidth > _maxImageWidth
        ? _maxImageWidth
        : constraints.maxWidth;
    final containerHeight = constraints.maxHeight.clamp(
      _minImageHeight,
      _maxImageHeight,
    );

    return Container(
      width: containerWidth,
      height: containerHeight,
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
      child: Padding(
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
      ),
    );
  }

  /// ✅ EMPTY STATE ADAPTATIVO
  Widget _buildEmptyState(BoxConstraints constraints) {
    final containerWidth = constraints.maxWidth > _maxImageWidth
        ? _maxImageWidth
        : constraints.maxWidth;
    final containerHeight = constraints.maxHeight.clamp(
      _minImageHeight,
      _maxImageHeight,
    );

    return Container(
      width: containerWidth,
      height: containerHeight,
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
      child: Padding(
        padding: _cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: _iconSize * 1.5, color: Colors.grey),
            SizedBox(height: _verticalSpaceMedium),
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
      ),
    );
  }

  /// ✅ CONTENEDOR ADAPTATIVO USANDO OptimizedImage UNIFICADO
  Widget _buildAdaptiveImageContainer(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: _maxImageWidth,
        maxHeight: _maxImageHeight,
        minHeight: _minImageHeight,
      ),
      child: OptimizedImage.newsHomeSection(
        assetPath: _homeNews!.imageUrl!,
        borderRadius: _cardRadius,
        showBorder: true,
        borderColor: Colors.grey.shade300,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: _cardElevation,
            offset: const Offset(0, 4),
          ),
        ],
        errorMessage: 'Error al cargar imagen',
      ),
    );
  }

  /// ✅ ESTADO CUANDO NO HAY IMAGEN - USANDO OptimizedImage CONSISTENTE
  Widget _buildNoImageState(BoxConstraints constraints) {
    final containerWidth = constraints.maxWidth > _maxImageWidth
        ? _maxImageWidth
        : constraints.maxWidth;
    final containerHeight = constraints.maxHeight.clamp(
      _minImageHeight,
      _maxImageHeight,
    );

    return Container(
      width: containerWidth,
      height: containerHeight,
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
      child: Padding(
        padding: _cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper,
              size: _iconSize * 1.5,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: _verticalSpaceMedium),
            Text(
              'Sin imagen disponible',
              style: TextStyle(
                fontSize: _captionFontSize,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
