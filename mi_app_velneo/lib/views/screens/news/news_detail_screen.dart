// lib/views/screens/news/news_detail_screen.dart - MEJORADO PARA CONTENIDO COMPLETO
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/views/widgets/common/category_widget.dart';
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

  /// ✅ LOGGING HELPER
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

  Future<void> _loadNews() async {
    try {
      _log('Cargando noticia con ID: ${widget.newsId}');
      final news = await NewsService.getNewsById(widget.newsId);
      setState(() {
        _news = news;
        _isLoading = false;
      });
      
      if (news != null) {
        _log('Noticia cargada: ${news.title}');
        _log('Contenido disponible: ${news.hasFullContent}');
        _log('Longitud contenido: ${news.content.length} caracteres');
      } else {
        _log('No se encontró la noticia');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _log('Error cargando noticia: $e');
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
        showLogo: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _news == null
          ? _buildErrorState()
          : _buildNewsContent(),
    );
  }

  /// ✅ ESTADO DE ERROR
  Widget _buildErrorState() {
    return Center(
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
          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  /// ✅ CONTENIDO PRINCIPAL DE LA NOTICIA
  Widget _buildNewsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ IMAGEN PRINCIPAL (si existe)
          if (_news!.hasValidImage) _buildHeroImage(),

          // ✅ CONTENIDO DE LA NOTICIA
          Padding(
            padding: ResponsiveHelper.getHorizontalPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                // ✅ INFORMACIÓN SUPERIOR (fecha y categoría)
                _buildNewsHeader(),

                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                // ✅ TÍTULO
                Text(
                  _news!.title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getTitleFontSize(context),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    height: 1.3,
                  ),
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                // ✅ CONTENIDO COMPLETO
                _buildContentText(),

                ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ HEADER CON FECHA Y CATEGORÍA
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
                size: ResponsiveHelper.getCaptionFontSize(context) + 2,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                _news!.formattedDate,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
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
                horizontal: ResponsiveHelper.getSmallSpacing(context),
                vertical: ResponsiveHelper.getSmallSpacing(context) * 0.5,
              ),
              textStyle: TextStyle(
                fontSize: ResponsiveHelper.getCaptionFontSize(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  /// ✅ CONTENIDO DE LA NOTICIA CON FORMATO
  Widget _buildContentText() {
    if (!_news!.hasFullContent) {
      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.getMediumSpacing(context)),
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
              size: ResponsiveHelper.getMenuButtonIconSize(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Contenido no disponible',
              style: TextStyle(
                fontSize: ResponsiveHelper.getBodyFontSize(context),
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    // ✅ MOSTRAR CONTENIDO CON FORMATO MEJORADO
    return SizedBox(
      width: double.infinity,
      child: Text(
        _news!.content,
        style: TextStyle(
          fontSize: ResponsiveHelper.getBodyFontSize(context),
          color: AppTheme.textPrimary,
          height: 1.6,
          letterSpacing: 0.3,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  /// ✅ IMAGEN HERO MEJORADA
  Widget _buildHeroImage() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: ResponsiveHelper.getScreenHeight(context) * 0.4,
        minHeight: ResponsiveHelper.getContainerMinHeight(context) * 1.5,
      ),
      child: Stack(
        children: [
          // ✅ IMAGEN PRINCIPAL
          Positioned.fill(
            child: _buildOptimizedImage(),
          ),

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

  /// ✅ IMAGEN OPTIMIZADA QUE MANEJA URLs Y ASSETS
  Widget _buildOptimizedImage() {
    final imageUrl = _news!.imageUrl!;
    
    // ✅ Si es una URL (como la de tu API)
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImageLoading();
        },
        errorBuilder: (context, error, stackTrace) {
          _log('Error cargando imagen: $imageUrl');
          return _buildImageError();
        },
      );
    }
    
    // ✅ Si es un asset local
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          _log('Error cargando asset: $imageUrl');
          return _buildImageError();
        },
      );
    }
    
    // ✅ Si no es reconocido, mostrar error
    return _buildImageError();
  }

  /// ✅ LOADING DE IMAGEN
  Widget _buildImageLoading() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
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
      ),
    );
  }

  /// ✅ ERROR DE IMAGEN
  Widget _buildImageError() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Error al cargar imagen',
              style: TextStyle(
                fontSize: ResponsiveHelper.getBodyFontSize(context),
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