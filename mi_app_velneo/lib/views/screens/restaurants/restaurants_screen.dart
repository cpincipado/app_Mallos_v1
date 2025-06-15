// lib/views/screens/restaurants/restaurants_screen.dart - COMPLETO FINAL - SIN PRINTS
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
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
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _searchController = TextEditingController();

  /// ✅ LOGGING HELPER
  void _log(String message) {
    if (kDebugMode) {
      print('RestaurantsScreen: $message');
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
      body: Column(
        children: [
          // ✅ Barra de búsqueda
          _buildSearchBar(),

          // ✅ Contenido principal
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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

          // ✅ Campo de búsqueda
          TextField(
            controller: _searchController,
            onChanged: _searchRestaurants,
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
            ),
            decoration: InputDecoration(
              hintText: 'Buscar restaurantes...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveHelper.getBodyFontSize(context),
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: _clearSearch,
                    )
                  : null,
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
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_filteredRestaurants.isEmpty) {
      return _buildEmptyState();
    }

    return _buildRestaurantsList();
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
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
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
            ),
            ResponsiveHelper.verticalSpace(context, SpacingSize.small),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: ResponsiveHelper.getBodyFontSize(context),
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            ResponsiveHelper.verticalSpace(context, SpacingSize.large),
            ElevatedButton.icon(
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchController.text.isNotEmpty;

    return Center(
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
                ? 'No se encontraron restaurantes'
                : 'No hay restaurantes disponibles',
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.small),
          Text(
            isSearching
                ? 'Prueba con otros términos de búsqueda'
                : 'Los restaurantes aparecerán aquí cuando estén disponibles',
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          if (isSearching) ...[
            ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
            TextButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar búsqueda'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRestaurantsList() {
    return RefreshIndicator(
      onRefresh: _refreshRestaurants,
      child: ListView.builder(
        padding: ResponsiveHelper.getHorizontalPadding(
          context,
        ).copyWith(top: ResponsiveHelper.getMediumSpacing(context)),
        itemCount: _filteredRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _filteredRestaurants[index];
          return _buildRestaurantCard(restaurant);
        },
      ),
    );
  }

  Widget _buildRestaurantCard(RestaurantModel restaurant) {
    return Container(
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
          // ✅ Imagen del restaurante
          _buildRestaurantImage(restaurant),

          // ✅ Información del restaurante
          Padding(
            padding: ResponsiveHelper.getCardPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y dirección
                Text(
                  restaurant.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getHeadingFontSize(context),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.small),

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

                // ✅ Descripción clickeable
                if (restaurant.description != null)
                  GestureDetector(
                    onTap: () => _showDescriptionModal(restaurant),
                    child: Text(
                      restaurant.description!,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getCaptionFontSize(context),
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                if (restaurant.description != null)
                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                // ✅ Horarios
                if (restaurant.schedule != null)
                  Text(
                    restaurant.schedule!.summarySchedule,
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
                        ),
                      ],
                    ),
                  ),
                ],

                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                // ✅ Botones de acción centrados
                _buildActionButtons(restaurant),
              ],
            ),
          ),
        ],
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
                semanticsLabel: 'Imagen de ${restaurant.name}',
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

    // ✅ Solo mostrar botones si tienen datos
    if (restaurant.hasLocation) {
      buttons.add(
        _buildActionButton(
          icon: Icons.location_on,
          onTap: () => _openGoogleMaps(restaurant),
          semanticsLabel: 'Ver ubicación de ${restaurant.name}',
        ),
      );
    }

    if (restaurant.primaryPhone != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.phone,
          onTap: () => _makePhoneCall(restaurant.primaryPhone!),
          semanticsLabel: 'Llamar a ${restaurant.name}',
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
          semanticsLabel: 'Ver promociones de ${restaurant.name}',
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: ResponsiveHelper.getMediumSpacing(context),
      children: buttons,
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
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              size: ResponsiveHelper.getMenuButtonIconSize(context) * 0.8,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  // ✅ MODAL DE DESCRIPCIÓN
  void _showDescriptionModal(RestaurantModel restaurant) {
    if (restaurant.description == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
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
                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // Nombre del restaurante
                    Text(
                      restaurant.name,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getSubtitleFontSize(context),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                    // Dirección
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size:
                              ResponsiveHelper.getCaptionFontSize(context) + 2,
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
                                ResponsiveHelper.getCaptionFontSize(context) +
                                2,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant.postalCode} ${restaurant.city ?? ''}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getCaptionFontSize(
                                context,
                              ),
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // Título "Descripción"
                    Text(
                      'Descripción',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getHeadingFontSize(context),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // Descripción completa
                    Text(
                      restaurant.description!,
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
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
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
                              '${restaurant.totalPoints} puntos disponibles',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getCaptionFontSize(
                                  context,
                                ),
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Horarios detallados si los tiene
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

                      ...restaurant.schedule!.detailedSchedule.map(
                        (schedule) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            schedule,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getCaptionFontSize(
                                context,
                              ),
                              color: AppTheme.textSecondary,
                            ),
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
      ),
    );
  }

  // ✅ MODAL DE PROMOCIONES
  void _showPromotionModal(RestaurantModel restaurant) {
    if (restaurant.promotion == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
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
                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

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
                                ),
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getHeadingFontSize(
                                          context,
                                        ),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // Título de la promoción
                    Text(
                      restaurant.promotion!.title,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getHeadingFontSize(context),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // Descripción de la promoción
                    Text(
                      restaurant.promotion!.description,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (restaurant.promotion!.terms != null) ...[
                      ResponsiveHelper.verticalSpace(
                        context,
                        SpacingSize.large,
                      ),

                      // Términos y condiciones
                      Text(
                        restaurant.promotion!.terms!,
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
      ),
    );
  }

  // ✅ FUNCIONES DE ACCIÓN
  Future<void> _openGoogleMaps(RestaurantModel restaurant) async {
    final Uri mapsUri = Uri.parse(restaurant.googleMapsUrl);
    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al abrir Google Maps')),
        );
      }
    }
  }

  Future<void> _makePhoneCall(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al realizar llamada')),
        );
      }
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    // Limpiar el número de teléfono (eliminar espacios, guiones, etc.)
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al abrir WhatsApp')),
        );
      }
    }
  }

  Future<void> _openWebsite(String website) async {
    final Uri websiteUri = Uri.parse(website);
    try {
      if (await canLaunchUrl(websiteUri)) {
        await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al abrir sitio web')),
        );
      }
    }
  }

  Future<void> _openInstagram(String instagram) async {
    final Uri instagramUri = Uri.parse('https://instagram.com/$instagram');
    try {
      if (await canLaunchUrl(instagramUri)) {
        await launchUrl(instagramUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al abrir Instagram')),
        );
      }
    }
  }

  Future<void> _openFacebook(String facebook) async {
    final Uri facebookUri = Uri.parse('https://facebook.com/$facebook');
    try {
      if (await canLaunchUrl(facebookUri)) {
        await launchUrl(facebookUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al abrir Facebook')),
        );
      }
    }
  }
}
