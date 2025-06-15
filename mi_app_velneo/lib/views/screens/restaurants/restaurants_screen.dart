// lib/views/screens/restaurants/restaurants_screen.dart - GRID RESPONSIVE CORREGIDO
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
  final Set<String> _favorites = <String>{}; // ✅ FINAL CORREGIDO
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

  /// ✅ VERIFICAR SI EL RESTAURANTE TIENE PROMOCIÓN VÁLIDA
  bool _hasValidPromotion(RestaurantModel restaurant) {
    // Verificar que existe promotion y que terms no esté vacío
    if (restaurant.promotion == null || restaurant.promotion!.terms == null) {
      return false;
    }

    // Limpiar el contenido HTML y verificar si queda contenido útil
    final cleanedPromotion = HtmlTextFormatter.getPromotion(
      restaurant.promotion!.terms!,
    );

    // Verificar que no sea el mensaje por defecto y que tenga contenido real
    return cleanedPromotion != 'Promoción non dispoñible' &&
        cleanedPromotion.isNotEmpty &&
        cleanedPromotion.length >
            10; // Debe tener al menos 10 caracteres de contenido real
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
          // ✅ Barra de búsqueda CORREGIDA - PERFECTA
          _buildSearchBar(),

          // ✅ Contenido principal
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  /// ✅ BARRA DE BÚSQUEDA CORREGIDA - PERFECTA Y CENTRADA
  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.getMediumSpacing(context)),
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
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.isDesktop(context)
                ? 600
                : double.infinity,
          ),
          child: Container(
            height: 48, // ✅ ALTURA FIJA OBLIGATORIA
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
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
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20, // ✅ TAMAÑO FIJO
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey.shade600,
                            size: 18, // ✅ TAMAÑO FIJO
                          ),
                          onPressed: _clearSearch,
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

  /// ✅ GRID RESPONSIVE CORREGIDO - USA SOLO ResponsiveHelper
  Widget _buildRestaurantsList() {
    return RefreshIndicator(
      onRefresh: _refreshRestaurants,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 🎯 CORREGIDO: Usar ResponsiveHelper para determinar columnas
          final crossAxisCount = _getResponsiveCrossAxisCount(context);
          final childAspectRatio = _getResponsiveAspectRatio(
            context,
            crossAxisCount,
          );

          return GridView.builder(
            padding: ResponsiveHelper.getHorizontalPadding(
              context,
            ).copyWith(top: ResponsiveHelper.getMediumSpacing(context)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: ResponsiveHelper.getMediumSpacing(context),
              mainAxisSpacing: ResponsiveHelper.getMediumSpacing(context),
              childAspectRatio: childAspectRatio,
            ),
            itemCount: _filteredRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = _filteredRestaurants[index];
              return _buildRestaurantCard(restaurant, crossAxisCount);
            },
          );
        },
      ),
    );
  }

  /// ✅ NUEVO: CÁLCULO DE COLUMNAS BASADO SOLO EN ResponsiveHelper
  int _getResponsiveCrossAxisCount(BuildContext context) {
    // 🎯 CORREGIDO: Usar SOLO ResponsiveHelper para breakpoints
    if (ResponsiveHelper.isMobile(context)) {
      return 1; // Móvil: 1 columna
    } else if (ResponsiveHelper.isTablet(context)) {
      return 2; // Tablet: 2 columnas
    } else {
      return 3; // Desktop: 3 columnas
    }
  }

  /// ✅ NUEVO: ASPECT RATIO ADAPTATIVO SEGÚN ResponsiveHelper
  double _getResponsiveAspectRatio(BuildContext context, int crossAxisCount) {
    if (ResponsiveHelper.isMobile(context)) {
      return 0.85; // Móvil: casi cuadrado para mejor UX
    } else if (ResponsiveHelper.isTablet(context)) {
      return 0.8; // Tablet: ligeramente más alto que ancho
    } else {
      return 0.75; // Desktop: más alto que ancho para compacidad
    }
  }

  Widget _buildRestaurantCard(RestaurantModel restaurant, int crossAxisCount) {
    final isFavorite = _favorites.contains(restaurant.id);
    final isMobile = ResponsiveHelper.isMobile(context);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Imagen del restaurante con AspectRatio adaptativo
          _buildRestaurantImage(restaurant, crossAxisCount),

          // ✅ Información del restaurante
          Expanded(
            child: Padding(
              padding: ResponsiveHelper.getCardPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎯 CORREGIDO: TÍTULO CON TODOS LOS BOTONES PRINCIPALES A LA DERECHA
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          maxLines: isMobile ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // 🎯 TODOS LOS BOTONES PRINCIPALES EN LA MISMA FILA
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✅ Puntos (si existen)
                          if (restaurant.totalPoints > 0) ...[
                            _buildPointsBadge(restaurant.totalPoints),
                            const SizedBox(width: 4),
                          ],

                          // ✅ Botón de llamada (si existe teléfono)
                          if (restaurant.primaryPhone != null) ...[
                            _buildCallButton(restaurant),
                            const SizedBox(width: 4),
                          ],

                          // ✅ Botón de favorito (siempre presente)
                          _buildFavoriteButton(restaurant.id, isFavorite),
                        ],
                      ),
                    ],
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                  // ✅ Dirección
                  Text(
                    restaurant.address,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      color: Colors.grey.shade600,
                    ),
                    maxLines: isMobile ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                  // ✅ DESCRIPCIÓN - Solo en móvil para ahorrar espacio
                  if (isMobile && restaurant.description != null) ...[
                    CleanHtmlText.preview(
                      htmlContent: restaurant.description,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getCaptionFontSize(context),
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ResponsiveHelper.verticalSpace(context, SpacingSize.small),
                  ],

                  // ✅ Horarios
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

                  // ✅ Spacer para empujar botones al final
                  const Spacer(),

                  // 🎯 CORREGIDO: Botones centrados sin spaceEvenly
                  _buildActionButtons(restaurant, isFavorite),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🎯 CORREGIDO: Solo botones secundarios (sin llamada ni favoritos)
  Widget _buildActionButtons(RestaurantModel restaurant, bool isFavorite) {
    List<Widget> buttons = [];

    // ✅ Solo botones secundarios (llamada y favoritos ya están arriba)
    if (restaurant.hasLocation) {
      buttons.add(
        _buildActionButton(
          icon: Icons.location_on,
          onTap: () => _openGoogleMaps(restaurant),
          semanticsLabel: 'Ver localización de ${restaurant.name}',
        ),
      );
    }

    // ✅ WHATSAPP - DIRECTO SIN MODAL
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

    // ✅ PROMOCIONES con verificación correcta
    if (_hasValidPromotion(restaurant)) {
      buttons.add(
        _buildActionButton(
          icon: Icons.card_giftcard,
          onTap: () => _showPromotionModal(restaurant),
          semanticsLabel: 'Ver promocións de ${restaurant.name}',
        ),
      );
    }

    // Si no hay botones secundarios, mostrar mensaje o espacio vacío
    if (buttons.isEmpty) {
      return const SizedBox(height: 8);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.isDesktop(context) ? 400 : double.infinity,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12, // Spacing fijo
        runSpacing: 8,
        children: buttons.take(4).toList(), // Máximo 4 botones secundarios
      ),
    );
  }

  Widget _buildRestaurantImage(RestaurantModel restaurant, int crossAxisCount) {
    // ✅ Aspect ratio adaptativo según número de columnas
    final aspectRatio = ResponsiveHelper.isMobile(context)
        ? 16 /
              9 // Móvil: más ancho
        : 4 / 3; // Tablet/Desktop: más cuadrado

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(ResponsiveHelper.getCardBorderRadius(context)),
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio,
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

  /// ✅ WIDGETS REUTILIZABLES PARA BOTONES
  Widget _buildPointsBadge(int points) {
    return Semantics(
      label: '$points puntos disponibles',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 12, color: AppTheme.primaryColor),
            const SizedBox(width: 2),
            Text(
              '$points',
              style: TextStyle(
                fontSize: ResponsiveHelper.getCaptionFontSize(context) - 1,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallButton(RestaurantModel restaurant) {
    return Semantics(
      label: 'Chamar a ${restaurant.name}',
      button: true,
      child: Material(
        color: Colors.green.shade50,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => _makePhoneCall(restaurant.primaryPhone!),
          customBorder: const CircleBorder(),
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.phone, size: 20, color: Colors.green.shade700),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(String restaurantId, bool isFavorite) {
    return Semantics(
      label: isFavorite ? 'Quitar de favoritos' : 'Engadir a favoritos',
      button: true,
      child: Material(
        color: isFavorite ? Colors.amber.shade50 : Colors.grey.shade50,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => _toggleFavorite(restaurantId),
          customBorder: const CircleBorder(),
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(10),
            child: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              size: 20,
              color: isFavorite ? Colors.amber.shade700 : Colors.grey.shade600,
            ),
          ),
        ),
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
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 20, color: Colors.grey.shade700),
          ),
        ),
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

  /// ✅ MODAL SOLO PARA PROMOCIONES EU CLUB MALLOS - USO CORRECTO DEL MÉTODO
  void _showPromotionModal(RestaurantModel restaurant) {
    // ✅ VERIFICACIÓN DOBLE - Solo abrir si realmente hay promoción válida
    if (!_hasValidPromotion(restaurant)) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LayoutBuilder(
        builder: (context, modalConstraints) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: modalConstraints.maxHeight * 0.9,
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

                        // ✅ TÍTULO "Promoción EU MALLOS"
                        Text(
                          'Promoción EU MALLOS',
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
                          SpacingSize.large,
                        ),

                        // ✅ CONTENIDO CORRECTO USANDO EL MÉTODO ESPECÍFICO
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(
                            ResponsiveHelper.getMediumSpacing(context),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            HtmlTextFormatter.getPromotion(
                              restaurant.promotion!.terms!,
                            ),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                              color: AppTheme.textPrimary,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),

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
}
