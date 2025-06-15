// lib/views/screens/news/news_list_screen.dart - COMPLETO CON IMÁGENES ADAPTATIVAS CORREGIDO

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/utils/image_dimensions_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/models/news_model.dart';
import 'package:mi_app_velneo/services/news_service.dart';
import 'package:mi_app_velneo/views/screens/news/news_detail_screen.dart';
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

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

  /// ✅ LOGGING CONDICIONAL
  void _log(String message) {
    if (kDebugMode) {
      debugPrint('NewsListScreen: $message');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          // ✅ BARRA DE BÚSQUEDA RESPONSIVE
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

  /// ✅ BARRA DE BÚSQUEDA RESPONSIVE
  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getHorizontalPadding(context).copyWith(
        top: ResponsiveHelper.getMediumSpacing(context),
        bottom: ResponsiveHelper.getMediumSpacing(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = ResponsiveHelper.isDesktop(context)
              ? 600.0
              : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                height: ResponsiveHelper.getButtonHeight(context),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getButtonBorderRadius(context) * 1.5,
                  ),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterNews,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getBodyFontSize(context),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar noticias...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size:
                            ResponsiveHelper.getMenuButtonIconSize(context) *
                            0.7,
                      ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey.shade600,
                                size:
                                    ResponsiveHelper.getMenuButtonIconSize(
                                      context,
                                    ) *
                                    0.6,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _filteredNews = _news;
                                });
                              },
                              tooltip: 'Limpiar búsqueda',
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ✅ LISTA DE NOTICIAS RESPONSIVE CON CONTENEDOR OPTIMIZADO
  Widget _buildNewsList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ✅ CONTENEDOR MÁS AMPLIO PARA DESKTOP
        final maxContentWidth = ResponsiveHelper.isDesktop(context)
            ? 1400.0 // Más ancho para permitir 3 columnas cómodas
            : ResponsiveHelper.isTablet(context)
            ? 1000.0 // Ancho intermedio para tablet
            : double.infinity; // Móvil usa todo el ancho

        if (kDebugMode) {
          debugPrint('📱 Constraints width: ${constraints.maxWidth}');
          debugPrint('📱 Max content width: $maxContentWidth');
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: ResponsiveHelper.getHorizontalPadding(
                context,
              ).copyWith(top: ResponsiveHelper.getMediumSpacing(context)),
              child: _buildNewsGrid(
                BoxConstraints(
                  maxWidth: maxContentWidth < constraints.maxWidth
                      ? maxContentWidth -
                            (ResponsiveHelper.getHorizontalPadding(
                              context,
                            ).horizontal)
                      : constraints.maxWidth -
                            (ResponsiveHelper.getHorizontalPadding(
                              context,
                            ).horizontal),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ✅ LAYOUT FLEXIBLE CON BREAKPOINTS CORREGIDOS
  Widget _buildNewsGrid(BoxConstraints constraints) {
    final screenWidth = ResponsiveHelper.getScreenWidth(context);

    if (kDebugMode) {
      debugPrint('📱 Screen width: ${screenWidth}px');
      debugPrint('📱 Is Mobile: ${ResponsiveHelper.isMobile(context)}');
      debugPrint('📱 Is Tablet: ${ResponsiveHelper.isTablet(context)}');
      debugPrint('📱 Is Desktop: ${ResponsiveHelper.isDesktop(context)}');
    }

    if (ResponsiveHelper.isMobile(context)) {
      // ✅ MÓVIL (<600px): 1 COLUMNA - Lista vertical
      if (kDebugMode) debugPrint('🔧 Usando layout MÓVIL - 1 columna');
      return ListView.builder(
        itemCount: _filteredNews.length,
        itemBuilder: (context, index) {
          final news = _filteredNews[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveHelper.getMediumSpacing(context),
            ),
            child: _buildAdaptiveNewsCard(news),
          );
        },
      );
    }

    // ✅ TABLET (600-900px): 2 COLUMNAS
    // ✅ DESKTOP (>900px): 3 COLUMNAS
    final crossAxisCount = ResponsiveHelper.isDesktop(context) ? 3 : 2;
    final spacing = ResponsiveHelper.getMediumSpacing(context);

    // ✅ CÁLCULO CORRECTO DEL ANCHO DISPONIBLE
    final totalSpacing = spacing * (crossAxisCount - 1);
    final availableWidth = constraints.maxWidth - totalSpacing;
    final cardWidth = availableWidth / crossAxisCount;

    if (kDebugMode) {
      debugPrint(
        '🔧 Usando layout ${ResponsiveHelper.isDesktop(context) ? "DESKTOP" : "TABLET"} - $crossAxisCount columnas',
      );
      debugPrint('📐 Constraints maxWidth: ${constraints.maxWidth}');
      debugPrint('📐 Total spacing: $totalSpacing');
      debugPrint('📐 Available width: $availableWidth');
      debugPrint('📐 Card width: $cardWidth');
    }

    return SingleChildScrollView(
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: _filteredNews.map((news) {
          return SizedBox(
            width: cardWidth,
            child: _buildAdaptiveNewsCard(news),
          );
        }).toList(),
      ),
    );
  }

  /// ✅ ESTADO VACÍO RESPONSIVE
  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = ResponsiveHelper.isDesktop(context)
            ? 400.0
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
                    _searchController.text.isEmpty
                        ? Icons.article_outlined
                        : Icons.search_off,
                    size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
                    color: Colors.grey,
                  ),
                  ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
                  Text(
                    _searchController.text.isEmpty
                        ? 'No hay noticias disponibles'
                        : 'No se encontraron noticias',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ✅ CARD COMPLETAMENTE ADAPTATIVO - SE AJUSTA A ORIENTACIÓN REAL
  Widget _buildAdaptiveNewsCard(NewsModel news) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: ResponsiveHelper.getCardElevation(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(news.id),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getCardBorderRadius(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ IMAGEN ADAPTATIVA - OCUPA EL ESPACIO QUE NECESITA
              if (news.hasValidImage)
                _buildCardImageFullyAdaptive(news.imageUrl!),

              // ✅ CONTENIDO DE LA NOTICIA - ESPACIO MÍNIMO NECESARIO
              Padding(
                padding: ResponsiveHelper.getCardPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ FECHA
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size:
                              ResponsiveHelper.getCaptionFontSize(context) + 2,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            news.formattedDate,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getCaptionFontSize(
                                context,
                              ),
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.xs),

                    // ✅ TÍTULO RESPONSIVE
                    Text(
                      news.title,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ IMAGEN QUE SE ADAPTA AL ASPECT RATIO REAL DE LA IMAGEN
  Widget _buildCardImageFullyAdaptive(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(ResponsiveHelper.getCardBorderRadius(context)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ USAR FutureBuilder PARA DETECTAR DIMENSIONES REALES
          return FutureBuilder<Size>(
            future: ImageDimensionsHelper.getImageDimensions(imageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Placeholder mientras detecta dimensiones
                return Container(
                  width: constraints.maxWidth,
                  height: 200, // Altura temporal
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              if (!snapshot.hasData) {
                // Fallback si no puede detectar dimensiones
                return SizedBox(
                  width: constraints.maxWidth,
                  height: 200,
                  child: OptimizedImage.newsAdaptive(
                    assetPath: imageUrl,
                    borderRadius: 0,
                    showBorder: false,
                    errorMessage: 'Error al cargar imagen',
                  ),
                );
              }

              final imageSize = snapshot.data!;
              final imageAspectRatio = imageSize.width / imageSize.height;

              // ✅ CALCULAR ALTURA BASADA EN ASPECT RATIO REAL
              final maxWidth = constraints.maxWidth;
              final calculatedHeight = maxWidth / imageAspectRatio;

              // ✅ LÍMITES PARA NO ROMPER EL LAYOUT
              final minHeight = ResponsiveHelper.isMobile(context)
                  ? 120.0
                  : 150.0;
              final maxHeight = ResponsiveHelper.isMobile(context)
                  ? 400.0
                  : 350.0;

              final finalHeight = calculatedHeight.clamp(minHeight, maxHeight);

              return SizedBox(
                width: maxWidth,
                height: finalHeight,
                child: OptimizedImage.newsAdaptive(
                  assetPath: imageUrl,
                  borderRadius: 0,
                  showBorder: false,
                  errorMessage: 'Error al cargar imagen',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
