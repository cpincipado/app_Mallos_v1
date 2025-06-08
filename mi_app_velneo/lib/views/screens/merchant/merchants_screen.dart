import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/models/merchant_model.dart';
import 'package:mi_app_velneo/services/merchant_service.dart';
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

class MerchantsScreen extends StatefulWidget {
  const MerchantsScreen({super.key});

  @override
  State<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
  List<MerchantModel> _merchants = [];
  List<MerchantModel> _filteredMerchants = [];
  List<String> _categories = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final merchants = await MerchantService.getAllMerchants();
      final categories = MerchantService.getAllCategories();

      setState(() {
        _merchants = merchants;
        _filteredMerchants = merchants;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar los comercios'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _searchAndFilter() async {
    final results = await MerchantService.searchAndFilterMerchants(
      query: _searchController.text,
      category: _selectedCategory,
    );

    setState(() {
      _filteredMerchants = results;
    });
  }

  void _selectCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _searchAndFilter();
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _searchController.clear();
      _filteredMerchants = _merchants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Mercamos?',
        showBackButton: true,
        showMenuButton: false,
        showFavoriteButton: false,
        showLogo: true,
      ),
      body: Column(
        children: [
          // ✅ Barra de búsqueda y filtros
          _buildSearchAndFilters(),

          // ✅ Lista de comercios
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMerchants.isEmpty
                ? _buildEmptyState()
                : _buildMerchantsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
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
            onChanged: (_) => _searchAndFilter(),
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
            ),
            decoration: InputDecoration(
              hintText: 'Buscar comercios...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveHelper.getBodyFontSize(context),
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon:
                  _searchController.text.isNotEmpty || _selectedCategory != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: _clearFilters,
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

          // ✅ Chips de categorías horizontales
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length + 1, // +1 para "Todos"
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Chip "Todos"
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        'Todos',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getCaptionFontSize(
                            context,
                          ),
                          color: _selectedCategory == null
                              ? Colors.white
                              : AppTheme.primaryColor,
                        ),
                      ),
                      selected: _selectedCategory == null,
                      onSelected: (_) => _selectCategory(null),
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: AppTheme.primaryColor,
                      checkmarkColor: Colors.white,
                    ),
                  );
                }

                final category = _categories[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getCaptionFontSize(context),
                        color: _selectedCategory == category
                            ? Colors.white
                            : AppTheme.primaryColor,
                      ),
                    ),
                    selected: _selectedCategory == category,
                    onSelected: (_) => _selectCategory(category),
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: AppTheme.primaryColor,
                    checkmarkColor: Colors.white,
                  ),
                );
              },
            ),
          ),

          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
        ],
      ),
    );
  }

  Widget _buildMerchantsList() {
    return ListView.builder(
      padding: ResponsiveHelper.getHorizontalPadding(
        context,
      ).copyWith(top: ResponsiveHelper.getMediumSpacing(context)),
      itemCount: _filteredMerchants.length,
      itemBuilder: (context, index) {
        final merchant = _filteredMerchants[index];
        return _buildMerchantCard(merchant);
      },
    );
  }

  Widget _buildMerchantCard(MerchantModel merchant) {
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
          // ✅ Imagen del comercio
          _buildMerchantImage(merchant),

          // ✅ Información del comercio
          Padding(
            padding: ResponsiveHelper.getCardPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y dirección
                Text(
                  merchant.name,
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
                  merchant.address,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaptionFontSize(context),
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                // ✅ Descripción clickeable
                if (merchant.description != null)
                  GestureDetector(
                    onTap: () => _showDescriptionModal(merchant),
                    child: Text(
                      merchant.description!,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getCaptionFontSize(context),
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                if (merchant.description != null)
                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                // ✅ Horarios
                if (merchant.schedule != null)
                  Text(
                    merchant.schedule!.summarySchedule,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                // ✅ Botones de acción centrados
                _buildActionButtons(merchant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantImage(MerchantModel merchant) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(ResponsiveHelper.getCardBorderRadius(context)),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: merchant.imageUrl != null
            ? OptimizedImage(
                assetPath: merchant.imageUrl!,
                fit: BoxFit.cover,
                semanticsLabel: 'Imagen de ${merchant.name}',
                fallback: _buildImagePlaceholder(merchant),
              )
            : _buildImagePlaceholder(merchant),
      ),
    );
  }

  Widget _buildImagePlaceholder(MerchantModel merchant) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.2,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            merchant.name,
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(MerchantModel merchant) {
    List<Widget> buttons = [];

    // ✅ Solo mostrar botones si tienen datos
    if (merchant.latitude != null && merchant.longitude != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.location_on,
          onTap: () => _openGoogleMaps(merchant),
          semanticsLabel: 'Ver ubicación de ${merchant.name}',
        ),
      );
    }

    if (merchant.phone != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.phone,
          onTap: () => _makePhoneCall(merchant.phone!),
          semanticsLabel: 'Llamar a ${merchant.name}',
        ),
      );
    }

    if (merchant.website != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.language,
          onTap: () => _openWebsite(merchant.website!),
          semanticsLabel: 'Visitar web de ${merchant.name}',
        ),
      );
    }

    if (merchant.instagram != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.camera_alt,
          onTap: () => _openInstagram(merchant.instagram!),
          semanticsLabel: 'Ver Instagram de ${merchant.name}',
        ),
      );
    }

    if (merchant.facebook != null) {
      buttons.add(
        _buildActionButton(
          icon: Icons.facebook,
          onTap: () => _openFacebook(merchant.facebook!),
          semanticsLabel: 'Ver Facebook de ${merchant.name}',
        ),
      );
    }

    if (merchant.hasPromotion) {
      buttons.add(
        _buildActionButton(
          icon: Icons.card_giftcard,
          onTap: () => _showPromotionModal(merchant),
          semanticsLabel: 'Ver promociones de ${merchant.name}',
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
            color: Colors.grey,
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
          Text(
            'No se encontraron comercios',
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.small),
          Text(
            'Prueba con otros términos de búsqueda',
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ✅ FUNCIONES DE ACCIÓN
  Future<void> _openGoogleMaps(MerchantModel merchant) async {
    final Uri mapsUri = Uri.parse(merchant.googleMapsUrl);
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

  // ✅ MODAL DE DESCRIPCIÓN
  void _showDescriptionModal(MerchantModel merchant) {
    if (merchant.description == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
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

                    // Nombre del comercio
                    Text(
                      merchant.name,
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
                            merchant.address,
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
                      merchant.description!,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                    // Categorías si las tiene
                    if (merchant.categories.isNotEmpty) ...[
                      ResponsiveHelper.verticalSpace(
                        context,
                        SpacingSize.large,
                      ),

                      Text(
                        'Categorías',
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
                        SpacingSize.small,
                      ),

                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: merchant.categories
                            .map(
                              (category) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getCaptionFontSize(
                                          context,
                                        ),
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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
  void _showPromotionModal(MerchantModel merchant) {
    if (merchant.promotion == null) return;

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

                    // ✅ Tarjeta EU MALLOS del comercio
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
                                  merchant.name,
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
                      merchant.promotion!.title,
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
                      merchant.promotion!.description,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (merchant.promotion!.terms != null) ...[
                      ResponsiveHelper.verticalSpace(
                        context,
                        SpacingSize.large,
                      ),

                      // Términos y condiciones
                      Text(
                        merchant.promotion!.terms!,
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
}
