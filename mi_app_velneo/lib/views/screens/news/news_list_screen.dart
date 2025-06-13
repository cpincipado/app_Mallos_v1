// lib/views/screens/news/news_list_screen.dart - ARCHIVO COMPLETO
import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
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
      final news = await NewsService.getAllNews();
      setState(() {
        _news = news;
        _filteredNews = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
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
          // Barra de búsqueda
          Container(
            padding: ResponsiveHelper.getHorizontalPadding(context),
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
                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                // Campo de búsqueda
                TextField(
                  controller: _searchController,
                  onChanged: _filterNews,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getBodyFontSize(context),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                    ),
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

                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
              ],
            ),
          ),

          // Lista de noticias
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNews.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchController.text.isEmpty
                              ? Icons.article_outlined
                              : Icons.search_off,
                          size:
                              ResponsiveHelper.getMenuButtonIconSize(context) *
                              1.5,
                          color: Colors.grey,
                        ),
                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No hay noticias disponibles'
                              : 'No se encontraron noticias',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getBodyFontSize(context),
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: ResponsiveHelper.getHorizontalPadding(context),
                    itemCount: _filteredNews.length,
                    itemBuilder: (context, index) {
                      final news = _filteredNews[index];
                      return _buildNewsCard(news);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(NewsModel news) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(newsId: news.id),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: ResponsiveHelper.getMediumSpacing(context),
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la noticia (si existe)
            if (news.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    ResponsiveHelper.getCardBorderRadius(context),
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _buildNewsImage(news.imageUrl!),
                ),
              ),

            // Contenido de la noticia
            Padding(
              padding: ResponsiveHelper.getCardPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fecha
                  Text(
                    news.formattedDate,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      color: Colors.grey.shade600,
                    ),
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                  // Título
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getHeadingFontSize(context),
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

  // ✅ MÉTODO AUXILIAR PARA MANEJAR IMÁGENES
  Widget _buildNewsImage(String imageUrl) {
    // Imagen local (assets)
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

    // Imagen de red (URL)
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImageLoading();
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError('Error al cargar imagen');
        },
      );
    }

    // URL inválida
    return _buildImageError('URL de imagen inválida');
  }

  // ✅ PLACEHOLDER MIENTRAS CARGA
  Widget _buildImageLoading() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Cargando imagen...',
              style: TextStyle(
                fontSize: ResponsiveHelper.getCaptionFontSize(context),
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ WIDGET DE ERROR
  Widget _buildImageError(String message) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: ResponsiveHelper.getMenuButtonIconSize(context),
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}