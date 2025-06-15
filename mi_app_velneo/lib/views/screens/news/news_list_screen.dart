// lib/views/screens/news/news_list_screen.dart - ULTRA OPTIMIZADA COMPLETA

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/news_service.dart';
import 'package:mi_app_velneo/views/screens/news/news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<NewsModel> _news = [];
  List<NewsModel> _filteredNews = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  // ✅ CACHE SIZES CALCULADOS UNA SOLA VEZ
  late final double _screenWidth;
  late final bool _isMobile;
  late final bool _isTablet;
  late final EdgeInsets _horizontalPadding;
  late final double _headingFontSize;
  late final double _bodyFontSize;
  late final double _captionFontSize;
  late final double _iconSize;
  late final double _cardBorderRadius;
  late final double _cardElevation;
  late final EdgeInsets _cardPadding;
  late final double _verticalSpaceMedium;
  late final double _verticalSpaceSmall;

  /// ✅ LOGGING CONDICIONAL
  void _log(String message) {
    if (kDebugMode) {
      print('NewsListScreen: $message');
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// ✅ PRE-CALCULAR TODOS LOS TAMAÑOS RESPONSIVE
  void _calculateSizes() {
    _screenWidth = MediaQuery.of(context).size.width;
    _isMobile = _screenWidth < 600;
    _isTablet = _screenWidth >= 600 && _screenWidth < 900;

    // ✅ TAMAÑOS OPTIMIZADOS SEGÚN DISPOSITIVO
    if (_isMobile) {
      _horizontalPadding = const EdgeInsets.symmetric(horizontal: 16.0);
      _headingFontSize = 16.0;
      _bodyFontSize = 14.0;
      _captionFontSize = 12.0;
      _iconSize = 28.0;
      _cardBorderRadius = 12.0;
      _cardElevation = 4.0;
      _cardPadding = const EdgeInsets.all(16.0);
      _verticalSpaceMedium = 12.0;
      _verticalSpaceSmall = 8.0;
    } else if (_isTablet) {
      _horizontalPadding = const EdgeInsets.symmetric(horizontal: 24.0);
      _headingFontSize = 18.0;
      _bodyFontSize = 15.0;
      _captionFontSize = 13.0;
      _iconSize = 30.0;
      _cardBorderRadius = 14.0;
      _cardElevation = 5.0;
      _cardPadding = const EdgeInsets.all(18.0);
      _verticalSpaceMedium = 14.0;
      _verticalSpaceSmall = 9.0;
    } else {
      _horizontalPadding = const EdgeInsets.symmetric(horizontal: 32.0);
      _headingFontSize = 20.0;
      _bodyFontSize = 16.0;
      _captionFontSize = 14.0;
      _iconSize = 32.0;
      _cardBorderRadius = 16.0;
      _cardElevation = 6.0;
      _cardPadding = const EdgeInsets.all(20.0);
      _verticalSpaceMedium = 16.0;
      _verticalSpaceSmall = 10.0;
    }
  }

  Future<void> _loadNews() async {
    try {
      _log('📰 Cargando lista de noticias...');
      final startTime = DateTime.now();

      final news = await NewsService.getAllNews();

      final loadTime = DateTime.now().difference(startTime).inMilliseconds;
      _log('⚡ ${news.length} noticias cargadas en ${loadTime}ms');

      if (mounted) {
        setState(() {
          _news = news;
          _filteredNews = news;
          _isLoading = false;
        });
      }
    } catch (e) {
      _log('❌ Error cargando noticias: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar las noticias'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterNews(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNews = _news;
      } else {
        _filteredNews = _news
            .where(
              (news) =>
                  news.title.toLowerCase().contains(query.toLowerCase()) ||
                  news.content.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _navigateToDetail(String newsId) {
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsDetailScreen(newsId: newsId)),
    );
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
      body: Column(
        children: [
          // ✅ BARRA DE BÚSQUEDA OPTIMIZADA
          _buildSearchBar(),

          // ✅ LISTA DE NOTICIAS
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNews.isEmpty
                ? _buildEmptyState()
                : _buildNewsList(),
          ),
        ],
      ),
    );
  }

  /// ✅ BARRA DE BÚSQUEDA CON TAMAÑOS PRE-CALCULADOS
  Widget _buildSearchBar() {
    return Container(
      padding: _horizontalPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: _verticalSpaceMedium),

          // Campo de búsqueda
          TextField(
            controller: _searchController,
            onChanged: _filterNews,
            style: TextStyle(fontSize: _bodyFontSize),
            decoration: InputDecoration(
              hintText: 'Buscar',
              hintStyle: TextStyle(color: Colors.grey, fontSize: _bodyFontSize),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
          ),

          SizedBox(height: _verticalSpaceMedium),
        ],
      ),
    );
  }

  /// ✅ LISTA DE NOTICIAS OPTIMIZADA
  Widget _buildNewsList() {
    return ListView.builder(
      padding: _horizontalPadding,
      itemCount: _filteredNews.length,
      itemBuilder: (context, index) {
        final news = _filteredNews[index];
        return _buildNewsCard(news);
      },
    );
  }

  /// ✅ ESTADO VACÍO CON TAMAÑOS PRE-CALCULADOS
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchController.text.isEmpty
                ? Icons.article_outlined
                : Icons.search_off,
            size: _iconSize * 1.5,
            color: Colors.grey,
          ),
          SizedBox(height: _verticalSpaceMedium),
          Text(
            _searchController.text.isEmpty
                ? 'No hay noticias disponibles'
                : 'No se encontraron noticias',
            style: TextStyle(fontSize: _bodyFontSize, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ✅ CARD DE NOTICIA ULTRA OPTIMIZADA
  Widget _buildNewsCard(NewsModel news) {
    return GestureDetector(
      onTap: () => _navigateToDetail(news.id),
      child: Container(
        margin: EdgeInsets.only(bottom: _verticalSpaceMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: _cardElevation,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ IMAGEN OPTIMIZADA (si existe)
            if (news.hasValidImage) _buildCardImage(news.imageUrl!),

            // ✅ CONTENIDO DE LA NOTICIA
            Padding(
              padding: _cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fecha
                  Text(
                    news.formattedDate,
                    style: TextStyle(
                      fontSize: _captionFontSize,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(height: _verticalSpaceSmall),

                  // Título
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: _headingFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ IMAGEN DE CARD ULTRA RÁPIDA
  Widget _buildCardImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(_cardBorderRadius),
      ),
      child: AspectRatio(aspectRatio: 16 / 9, child: _buildFastImage(imageUrl)),
    );
  }

  /// ✅ IMAGEN ULTRA OPTIMIZADA - SIN CachedNetworkImage
  Widget _buildFastImage(String imageUrl) {
    // ✅ URL remota - directo
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        // ✅ SIN loadingBuilder para máxima velocidad
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError('Error al cargar imagen');
        },
      );
    }

    // ✅ Asset local - directo
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError('Error al cargar imagen');
        },
      );
    }

    // ✅ URL inválida
    return _buildImageError('URL de imagen inválida');
  }

  /// ✅ ERROR DE IMAGEN SIMPLE
  Widget _buildImageError(String message) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: _iconSize,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: _captionFontSize,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
