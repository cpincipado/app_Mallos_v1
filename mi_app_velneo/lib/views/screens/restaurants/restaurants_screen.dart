// lib/views/screens/restaurants/restaurants_screen.dart - VERSIÓN CORREGIDA PROFESIONAL
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/utils/html_text_formatter.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/models/restaurant_model.dart';
import 'package:mi_app_velneo/services/restaurant_service.dart';
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  List<RestaurantModel> _restaurants = [];
  List<RestaurantModel> _filteredRestaurants = [];
  Set<String> _favorites = <String>{}; // ✅ Lista de favoritos
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _searchController = TextEditingController();

  /// ✅ LOGGING HELPER CONDICIONAL
  void _log(String message) {
    if (kDebugMode) {
      debugPrint('RestaurantsScreen: $message');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRestaurants() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _log('Iniciando carga de restaurantes...');
      final restaurants = await RestaurantService.getAllRestaurants();

      _log('Restaurantes cargados: ${restaurants.length}');

      if (mounted) {
        setState(() {
          _restaurants = restaurants;
          _filteredRestaurants = restaurants;
          _isLoading = false;
        });
      }
    } catch (e) {
      _log('Error cargando restaurantes: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  void _searchRestaurants(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredRestaurants = _restaurants;
      });
      return;
    }

    try {
      final results = await RestaurantService.searchRestaurants(query);
      if (mounted) {
        setState(() {
          _filteredRestaurants = results;
        });
      }
    } catch (e) {
      _log('Error en búsqueda: $e');
      // En caso de error en búsqueda, filtrar localmente
      final lowerQuery = query.toLowerCase();
      setState(() {
        _filteredRestaurants = _restaurants.where((restaurant) {
          return restaurant.name.toLowerCase().contains(lowerQuery) ||
              restaurant.address.toLowerCase().contains(lowerQuery) ||
              (restaurant.city?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredRestaurants = _restaurants;
    });
  }

  Future<void> _refreshRestaurants() async {
    await _loadRestaurants();
  }

  // ✅ Toggle favorito
  void _toggleFavorite(String restaurantId) {
    setState(() {
      if (_favorites.contains(restaurantId)) {
        _favorites.remove(restaurantId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Eliminado de favoritos'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        _favorites.add(restaurantId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Añadido a favoritos'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'A nosa hostalería',
        showBackButton: true,
        showMenuButton: false,
        showFavoriteButton: false,
        showLogo: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // ✅ Barra de búsqueda CORREGIDA responsive
              _buildSearchBar(constraints),

              // ✅ Contenido principal
              Expanded(child: _buildMainContent(constraints)),
            ],
          );
        },
      ),
    );
  }

  /// ✅ BARRA DE BÚSQUEDA CORREGIDA - RESPONSIVE PERFECTO
  Widget _buildSearchBar(BoxConstraints constraints) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.isDesktop(context) ? 600 : double.infinity,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.isDesktop(context) ? 24 : 16,
        vertical: ResponsiveHelper.getMediumSpacing(context),
      ),
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
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.isDesktop(context)
                ? 500
                : double.infinity,
          ),
          child: Container(
            height: 48, // ✅ ALTURA FIJA OBLIGATORIA
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _searchRestaurants,
              style: TextStyle(
                fontSize: ResponsiveHelper.getBodyFontSize(context),
              ),
              decoration: InputDecoration(
                hintText: 'Buscar restaurantes...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: ResponsiveHelper.getBodyFontSize(context),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20, // ✅ TAMAÑO FIJO ICONO
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade600,
                          size: 20, // ✅ TAMAÑO FIJO ICONO
                        ),
                        onPressed: _clearSearch,
                        tooltip: 'Limpiar búsqueda',
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BoxConstraints constraints) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_filteredRestaurants.isEmpty) {
      return _buildEmptyState();
    }

    return _buildRestaurantsList(constraints);
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Cargando restaurantes...',
            style: TextStyle(color: Colors.grey, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.isDesktop(context) ? 400 : double.infinity,
        ),
        child: Padding(
          padding: ResponsiveHelper.getHorizontalPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
              Text(
                'Error al cargar restaurantes',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getHeadingFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              ResponsiveHelper.verticalSpace(context, SpacingSize.small),
              Text(
                _errorMessage!,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getBodyFontSize(context),
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              ResponsiveHelper.verticalSpace(context, SpacingSize.large),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
                child: ElevatedButton.icon(
                  onPressed: _refreshRestaurants,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchController.text.isNotEmpty;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.isDesktop(context) ? 400 : double.infinity,
        ),
        child: Padding(
          padding: ResponsiveHelper.getHorizontalPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSearching ? Icons.search_off : Icons.restaurant_outlined,
                size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
                color: Colors.grey,
              ),
              ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
              Text(
                isSearching
                    ? 'Non se atoparon restaurantes'
                    : 'Non hai restaurantes dispoñibles',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getBodyFontSize(context),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              ResponsiveHelper.verticalSpace(context, SpacingSize.small),
              Text(
                isSearching
                    ? 'Proba con outros termos de búsqueda'
                    : 'Os restaurantes aparecerán aquí cando estean dispoñibles',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (isSearching) ...[
                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
                TextButton.icon(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpar búsqueda'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantsList(BoxConstraints constraints) {
    return RefreshIndicator(
      onRefresh: _refreshRestaurants,
      child: LayoutBuilder(
        builder: (context, listConstraints) {
          return ListView.builder(
            padding: ResponsiveHelper.getHorizontalPadding(
              context,
            ).copyWith(top: ResponsiveHelper.getMediumSpacing(context)),
            itemCount: _filteredRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = _filteredRestaurants[index];
              return _buildRestaurantCard(restaurant, listConstraints);
            },
          );
        },
      ),
    );
  }

  Widget _buildRestaurantCard(
    RestaurantModel restaurant,
    BoxConstraints constraints,
  ) {
    final isFavorite = _favorites.contains(restaurant.id);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.isDesktop(context) ? 600 : double.infinity,
      ),
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
            // ✅ Imagen del restaurante con límites
            _buildRestaurantImage(restaurant),

            // ✅ Información del restaurante
            Padding(
              padding: ResponsiveHelper.getCardPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ FILA: Título + Botones (Llamada + Favorito)
                  Row(
                    children: [
                      // Título expandible
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getHeadingFontSize(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ✅ Botón de llamada (si tiene teléfono)
                      if (restaurant.primaryPhone != null)
                        Semantics(
                          label: 'Chamar a ${restaurant.name}',
                          button: true,
                          child: Material(
                            color: Colors.green.shade50,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () =>
                                  _makePhoneCall(restaurant.primaryPhone!),
                              customBorder: const CircleBorder(),
                              child: Container(
                                width: 36,
                                height: 36,
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.phone,
                                  size: 20,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(width: 4),

                      // ✅ Botón de favorito
                      Semantics(
                        label: isFavorite
                            ? 'Quitar de favoritos'
                            : 'Engadir a favoritos',
                        button: true,
                        child: Material(
                          color: isFavorite
                              ? Colors.amber.shade50
                              : Colors.grey.shade50,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () => _toggleFavorite(restaurant.id),
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 36,
                              height: 36,
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                size: 20,
                                color: isFavorite
                                    ? Colors.amber.shade700
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                  // Dirección
                  Text(
                    restaurant.address,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                  // ✅ DESCRIPCIÓN CON WIDGET PREVIEW - clickeable
                  if (restaurant.description != null)
                    RestaurantDescriptionText.preview(
                      description: restaurant.description,
                      onTap: () => _showDescriptionModal(restaurant),
                    ),

                  if (restaurant.description != null)
                    ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                  // ✅ Horarios - CORREGIDO CON LIMPIEZA ESPECÍFICA
                  if (restaurant.schedule != null)
                    Text(
                      HtmlTextFormatter.getSchedule(
                        restaurant.schedule!.summarySchedule,
                      ),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getCaptionFontSize(context),
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // ✅ Mostrar puntos si los tiene
                  if (restaurant.totalPoints > 0) ...[
                    ResponsiveHelper.verticalSpace(context, SpacingSize.small),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant.totalPoints} puntos',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveHelper.getCaptionFontSize(context) -
                                  1,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],

                  ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                  // ✅ Botones de acción restantes
                  _buildActionButtons(restaurant),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantImage(RestaurantModel restaurant) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(ResponsiveHelper.getCardBorderRadius(context)),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: restaurant.imageUrl != null
            ? OptimizedImage(
                assetPath: restaurant.imageUrl!,
                fit: BoxFit.cover,
                semanticsLabel: 'Imaxe de ${restaurant.name}',
                fallback: _buildImagePlaceholder(restaurant),
              )
            : _buildImagePlaceholder(restaurant),
      ),
    );
  }

  Widget _buildImagePlaceholder(RestaurantModel restaurant) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.2,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              restaurant.name,
              style: TextStyle(
                fontSize: ResponsiveHelper.getCaptionFontSize(context),
                color: Colors.grey.shade600,
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

  Widget _buildActionButtons(RestaurantModel restaurant) {
    List<Widget> buttons = [];

    // ✅ Solo mostrar botones restantes (ubicación, web, redes sociales, promociones)
    if (restaurant.hasLocation) {
      buttons.add(
        _buildActionButton(
          icon: Icons.location_on,
          onTap: () => _openGoogleMaps(restaurant),
          semanticsLabel: 'Ver localización de ${restaurant.name}',
        ),
      );
    }

    // ✅ WhatsApp si es diferente del teléfono principal
    if (restaurant.whatsapp != null &&
        restaurant.whatsapp != restaurant.primaryPhone) {
      buttons.add(
        _buildActionButton(
          icon: Icons.chat,
          onTap: () => _openWhatsApp(restaurant.whatsapp!),
          semanticsLabel: 'WhatsApp ${restaurant.name}',
        ),
      );
    }

    if (restaurant.website != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.language,
          onTap: () => _openWebsite(restaurant.website!),
          semanticsLabel: 'Visitar web de ${restaurant.name}',
        ),
      );
    }

    if (restaurant.instagram != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.camera_alt,
          onTap: () => _openInstagram(restaurant.instagram!),
          semanticsLabel: 'Ver Instagram de ${restaurant.name}',
        ),
      );
    }

    if (restaurant.facebook != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.facebook,
          onTap: () => _openFacebook(restaurant.facebook!),
          semanticsLabel: 'Ver Facebook de ${restaurant.name}',
        ),
      );
    }

    if (restaurant.hasPromotion) {
      buttons.add(
        _buildActionButton(
          icon: Icons.card_giftcard,
          onTap: () => _showPromotionModal(restaurant),
          semanticsLabel: 'Ver promocións de ${restaurant.name}',
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.isDesktop(context) ? 400 : double.infinity,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: ResponsiveHelper.getMediumSpacing(context),
        children: buttons,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: Material(
        color: Colors.grey.shade100,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 16, color: Colors.grey.shade700),
          ),
        ),
      ),
    );
  }

  /// ✅ MODAL DE DESCRIPCIÓN CORREGIDO - SIN OVERFLOW
  void _showDescriptionModal(RestaurantModel restaurant) {
    if (restaurant.description == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LayoutBuilder(
        builder: (context, modalConstraints) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: modalConstraints.maxHeight * 0.8,
              maxWidth: ResponsiveHelper.isDesktop(context)
                  ? 600
                  : double.infinity,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle del modal
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: ResponsiveHelper.getCardPadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),

                        // Nombre del restaurante
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getSubtitleFontSize(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.small,
                        ),

                        // Dirección
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size:
                                  ResponsiveHelper.getCaptionFontSize(context) +
                                  2,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                restaurant.address,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getCaptionFontSize(
                                    context,
                                  ),
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // ✅ Código postal si existe
                        if (restaurant.postalCode != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.local_post_office_outlined,
                                size:
                                    ResponsiveHelper.getCaptionFontSize(
                                      context,
                                    ) +
                                    2,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${restaurant.postalCode} ${restaurant.city ?? ''}',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getCaptionFontSize(
                                          context,
                                        ),
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.large,
                        ),

                        // Título "Descripción"
                        Text(
                          'Descrición',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getHeadingFontSize(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),

                        // ✅ DESCRIPCIÓN CON WIDGET HTML COMPLETO - CORREGIDA
                        CleanHtmlText(
                          htmlContent: restaurant.description!,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getBodyFontSize(context),
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),

                        // ✅ Mostrar puntos totales si los tiene
                        if (restaurant.totalPoints > 0) ...[
                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.medium,
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${restaurant.totalPoints} puntos dispoñibles',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getCaptionFontSize(
                                          context,
                                        ),
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],

                        // ✅ Horarios detallados CORREGIDOS - CON LIMPIEZA HTML
                        if (restaurant.schedule != null) ...[
                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.large,
                          ),

                          Text(
                            'Horarios',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getHeadingFontSize(
                                context,
                              ),
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),

                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.medium,
                          ),

                          // ✅ HORARIOS CON LIMPIEZA HTML ESPECÍFICA
                          ...restaurant.schedule!.detailedSchedule.map(
                            (schedule) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                HtmlTextFormatter.getSchedule(schedule),
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getCaptionFontSize(
                                    context,
                                  ),
                                  color: AppTheme.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],

                        ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ✅ MODAL DE PROMOCIONES CORREGIDO - SIN OVERFLOW
  void _showPromotionModal(RestaurantModel restaurant) {
    if (restaurant.promotion == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LayoutBuilder(
        builder: (context, modalConstraints) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: modalConstraints.maxHeight * 0.8,
              maxWidth: ResponsiveHelper.isDesktop(context)
                  ? 600
                  : double.infinity,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle del modal
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: ResponsiveHelper.getCardPadding(context),
                    child: Column(
                      children: [
                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),

                        // ✅ Tarjeta EU MALLOS del restaurante
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 16,
                                top: 16,
                                child: Icon(
                                  Icons.credit_card,
                                  size: 24,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                              Positioned(
                                left: 16,
                                bottom: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Club EU MALLOS',
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.getCaptionFontSize(
                                              context,
                                            ),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 200,
                                      ),
                                      child: Text(
                                        restaurant.name,
                                        style: TextStyle(
                                          fontSize:
                                              ResponsiveHelper.getHeadingFontSize(
                                                context,
                                              ),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.large,
                        ),

                        // ✅ TÍTULO DE PROMOCIÓN CON WIDGET
                        CleanHtmlText.title(
                          htmlContent: restaurant.promotion!.title,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getHeadingFontSize(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.medium,
                        ),

                        // ✅ DESCRIPCIÓN DE PROMOCIÓN CON WIDGET
                        CleanHtmlText(
                          htmlContent: restaurant.promotion!.description,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getBodyFontSize(context),
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // ✅ TÉRMINOS CON WIDGET SI EXISTEN
                        if (restaurant.promotion!.terms != null) ...[
                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.large,
                          ),

                          CleanHtmlText(
                            htmlContent: restaurant.promotion!.terms!,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getCaptionFontSize(
                                context,
                              ),
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],

                        ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ FUNCIONES DE ACCIÓN CON MOUNTED CHECK Y TRY-CATCH
  Future<void> _openGoogleMaps(RestaurantModel restaurant) async {
    if (!mounted) return;

    final Uri mapsUri = Uri.parse(restaurant.googleMapsUrl);
    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _log('Error abriendo Google Maps: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao abrir Google Maps')),
        );
      }
    }
  }

  Future<void> _makePhoneCall(String phone) async {
    if (!mounted) return;

    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      _log('Error realizando llamada: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao realizar chamada')),
        );
      }
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    if (!mounted) return;

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _log('Error abriendo WhatsApp: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao abrir WhatsApp')));
      }
    }
  }

  Future<void> _openWebsite(String website) async {
    if (!mounted) return;

    final Uri websiteUri = Uri.parse(website);
    try {
      if (await canLaunchUrl(websiteUri)) {
        await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _log('Error abriendo website: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao abrir sitio web')),
        );
      }
    }
  }

  Future<void> _openInstagram(String instagram) async {
    if (!mounted) return;

    final Uri instagramUri = Uri.parse('https://instagram.com/$instagram');
    try {
      if (await canLaunchUrl(instagramUri)) {
        await launchUrl(instagramUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _log('Error abriendo Instagram: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao abrir Instagram')),
        );
      }
    }
  }

  Future<void> _openFacebook(String facebook) async {
    if (!mounted) return;

    final Uri facebookUri = Uri.parse('https://facebook.com/$facebook');
    try {
      if (await canLaunchUrl(facebookUri)) {
        await launchUrl(facebookUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _log('Error abriendo Facebook: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao abrir Facebook')));
      }
    }
  }
}
