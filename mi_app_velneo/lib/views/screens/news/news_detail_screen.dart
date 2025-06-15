// lib/views/screens/news/news_detail_screen.dart - ULTRA OPTIMIZADA COMPLETA

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/views/widgets/common/category_widget.dart';
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/news_service.dart';
import 'package:mi_app_velneo/utils/html_text_formatter.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  NewsModel? _news;
  bool _isLoading = true;

  // ✅ CACHE SIZES CALCULADOS UNA SOLA VEZ
  late final double _screenWidth;
  late final double _screenHeight;
  late final bool _isMobile;
  late final bool _isTablet;
  late final EdgeInsets _horizontalPadding;
  late final double _titleFontSize;
  late final double _bodyFontSize;
  late final double _captionFontSize;
  late final double _iconSize;
  late final double _verticalSpaceMedium;
  late final double _verticalSpaceLarge;
  late final double _verticalSpaceXL;

  /// ✅ LOGGING CONDICIONAL
  void _log(String message) {
    if (kDebugMode) {
      print('NewsDetailScreen: $message');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ CALCULAR TAMAÑOS UNA SOLA VEZ
    _calculateSizes();
  }

  /// ✅ PRE-CALCULAR TODOS LOS TAMAÑOS RESPONSIVE
  void _calculateSizes() {
    final screenSize = MediaQuery.of(context).size;
    _screenWidth = screenSize.width;
    _screenHeight = screenSize.height;

    _isMobile = _screenWidth < 600;
    _isTablet = _screenWidth >= 600 && _screenWidth < 900;

    // ✅ TAMAÑOS OPTIMIZADOS SEGÚN DISPOSITIVO
    if (_isMobile) {
      _horizontalPadding = const EdgeInsets.symmetric(horizontal: 16.0);
      _titleFontSize = 22.0;
      _bodyFontSize = 16.0;
      _captionFontSize = 12.0;
      _iconSize = 16.0;
      _verticalSpaceMedium = 12.0;
      _verticalSpaceLarge = 16.0;
      _verticalSpaceXL = 24.0;
    } else if (_isTablet) {
      _horizontalPadding = const EdgeInsets.symmetric(horizontal: 24.0);
      _titleFontSize = 24.0;
      _bodyFontSize = 17.0;
      _captionFontSize = 13.0;
      _iconSize = 18.0;
      _verticalSpaceMedium = 14.0;
      _verticalSpaceLarge = 18.0;
      _verticalSpaceXL = 28.0;
    } else {
      _horizontalPadding = const EdgeInsets.symmetric(horizontal: 32.0);
      _titleFontSize = 26.0;
      _bodyFontSize = 18.0;
      _captionFontSize = 14.0;
      _iconSize = 20.0;
      _verticalSpaceMedium = 16.0;
      _verticalSpaceLarge = 20.0;
      _verticalSpaceXL = 32.0;
    }
  }

  Future<void> _loadNews() async {
    try {
      _log('📰 Cargando noticia ID: ${widget.newsId}');
      final startTime = DateTime.now();

      final news = await NewsService.getNewsById(widget.newsId);

      final loadTime = DateTime.now().difference(startTime).inMilliseconds;
      _log('⚡ Noticia cargada en ${loadTime}ms');

      if (mounted) {
        setState(() {
          _news = news;
          _isLoading = false;
        });

        if (news != null) {
          _log('✅ Noticia mostrada: ${news.title}');
          _log(
            '📄 Contenido: ${news.hasFullContent ? 'Disponible' : 'No disponible'}',
          );
        } else {
          _log('❌ Noticia no encontrada');
        }
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

  /// ✅ LOADING STATE SIMPLE
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  /// ✅ ERROR STATE OPTIMIZADO
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: _iconSize * 3, color: Colors.grey),
          SizedBox(height: _verticalSpaceMedium),
          Text(
            'Noticia no encontrada',
            style: TextStyle(fontSize: _bodyFontSize, color: Colors.grey),
          ),
          SizedBox(height: _verticalSpaceMedium),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  /// ✅ CONTENIDO PRINCIPAL OPTIMIZADO
  Widget _buildNewsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ IMAGEN PRINCIPAL (si existe)
          if (_news!.hasValidImage) _buildHeroImage(),

          // ✅ CONTENIDO DE LA NOTICIA
          Padding(
            padding: _horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: _verticalSpaceLarge),

                // ✅ HEADER CON FECHA Y CATEGORÍA
                _buildNewsHeader(),

                SizedBox(height: _verticalSpaceMedium),

                // ✅ TÍTULO CON TAMAÑOS PRE-CALCULADOS
                Text(
                  _news!.title,
                  style: TextStyle(
                    fontSize: _titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: _verticalSpaceLarge),

                // ✅ CONTENIDO COMPLETO CON HTML FORMATTER
                _buildContentText(),

                SizedBox(height: _verticalSpaceXL),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ HEADER OPTIMIZADO CON TAMAÑOS PRE-CALCULADOS
  Widget _buildNewsHeader() {
    return Row(
      children: [
        // Fecha
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: _captionFontSize + 2,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                _news!.formattedDate,
                style: TextStyle(
                  fontSize: _captionFontSize,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Categoría (si existe)
        if (_news!.categoryId != null)
          Expanded(
            flex: 1,
            child: CategoryWidget(
              categoryId: _news!.categoryId,
              padding: EdgeInsets.symmetric(
                horizontal: _verticalSpaceMedium * 0.5,
                vertical: _verticalSpaceMedium * 0.25,
              ),
              textStyle: TextStyle(
                fontSize: _captionFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  /// ✅ CONTENIDO CON HTML FORMATTER OPTIMIZADO
  Widget _buildContentText() {
    if (!_news!.hasFullContent) {
      return Container(
        padding: EdgeInsets.all(_verticalSpaceMedium),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey.shade500,
              size: _iconSize * 2,
            ),
            const SizedBox(height: 8),
            Text(
              'Contenido no disponible',
              style: TextStyle(
                fontSize: _bodyFontSize,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    // ✅ USAR HtmlTextFormatter PARA LIMPIAR HTML
    return CleanHtmlText(
      htmlContent: _news!.content,
      style: TextStyle(
        fontSize: _bodyFontSize,
        color: AppTheme.textPrimary,
        height: 1.6,
        letterSpacing: 0.3,
      ),
    );
  }

  /// ✅ IMAGEN HERO ULTRA OPTIMIZADA
  Widget _buildHeroImage() {
    final maxHeight = _screenHeight * 0.4;
    final minHeight = _isMobile ? 200.0 : 250.0;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: maxHeight, minHeight: minHeight),
      child: Stack(
        children: [
          // ✅ IMAGEN PRINCIPAL SIN CachedNetworkImage
          Positioned.fill(child: _buildFastImage()),

          // ✅ GRADIENTE INFERIOR
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

  /// ✅ IMAGEN ULTRA RÁPIDA - SIN LOADING BUILDER
  Widget _buildFastImage() {
    final imageUrl = _news!.imageUrl!;

    // ✅ URL remota - directo sin cache
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        // ✅ SIN loadingBuilder para máxima velocidad
        errorBuilder: (context, error, stackTrace) {
          _log('Error imagen: $imageUrl');
          return _buildImageError();
        },
      );
    }

    // ✅ Asset local - directo
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          _log('Error asset: $imageUrl');
          return _buildImageError();
        },
      );
    }

    // ✅ URL inválida
    return _buildImageError();
  }

  /// ✅ ERROR DE IMAGEN SIMPLE
  Widget _buildImageError() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: _iconSize * 3,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Error al cargar imagen',
              style: TextStyle(
                fontSize: _bodyFontSize,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
