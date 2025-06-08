import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/models/parking_model.dart';
import 'package:mi_app_velneo/services/parking_service.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<ParkingModel> _parkings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParkings();
  }

  Future<void> _loadParkings() async {
    try {
      final parkings = await ParkingService.getAllParkings();
      setState(() {
        _parkings = parkings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar los parkings'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openGoogleMaps(ParkingModel parking) async {
    final Uri mapsUri = Uri.parse(parking.googleMapsUrl);

    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se pudo abrir Google Maps');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir Google Maps: ${e.toString()}'),
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
        title: 'Parking',
        showBackButton: true,
        showMenuButton: false,
        showFavoriteButton: false,
        showLogo: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ RESPONSIVE: Layout adaptativo
          final maxContentWidth = ResponsiveHelper.isDesktop(context)
              ? 600.0
              : double.infinity;

          return SingleChildScrollView(
            padding: ResponsiveHelper.getHorizontalPadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  children: [
                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // ✅ Ilustración de parking - RESPONSIVE
                    _buildParkingIllustration(context),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // ✅ Lista de parkings
                    _isLoading
                        ? _buildLoadingState()
                        : _parkings.isEmpty
                        ? _buildEmptyState()
                        : _buildParkingsList(),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParkingIllustration(BuildContext context) {
    // ✅ Tamaño controlado de ilustración
    final illustrationHeight = ResponsiveHelper.isDesktop(context)
        ? 200.0
        : ResponsiveHelper.isTablet(context)
        ? 180.0
        : 160.0;

    return Container(
      width: double.infinity,
      height: illustrationHeight,
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.isDesktop(context) ? 400 : double.infinity,
        maxHeight: illustrationHeight,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono de parking
          Container(
            width: ResponsiveHelper.getMenuButtonIconSize(context) * 2,
            height: ResponsiveHelper.getMenuButtonIconSize(context) * 2,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_parking,
              size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.2,
              color: Colors.blue.shade700,
            ),
          ),

          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

          // Texto
          Text(
            'Aparcamientos Disponibles',
            style: TextStyle(
              fontSize: ResponsiveHelper.getHeadingFontSize(context),
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
            textAlign: TextAlign.center,
          ),

          ResponsiveHelper.verticalSpace(context, SpacingSize.small),

          Text(
            'Toca cualquier parking para ver su ubicación en Google Maps',
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.blue.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        const CircularProgressIndicator(),
        ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
        Text(
          'Cargando parkings...',
          style: TextStyle(
            fontSize: ResponsiveHelper.getCaptionFontSize(context),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(
          Icons.local_parking_outlined,
          size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
          color: Colors.grey,
        ),
        ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
        Text(
          'No hay parkings disponibles',
          style: TextStyle(
            fontSize: ResponsiveHelper.getBodyFontSize(context),
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildParkingsList() {
    return Column(
      children: _parkings
          .map((parking) => _buildParkingButton(parking))
          .toList(),
    );
  }

  Widget _buildParkingButton(ParkingModel parking) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getMediumSpacing(context),
      ),
      child: Semantics(
        label: 'Abrir ${parking.name} en Google Maps',
        button: true,
        child: Material(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getButtonBorderRadius(context),
          ),
          elevation: ResponsiveHelper.getCardElevation(context),
          child: InkWell(
            onTap: () => _openGoogleMaps(parking),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getButtonBorderRadius(context),
            ),
            child: Container(
              width: double.infinity,
              height:
                  ResponsiveHelper.getButtonHeight(context) +
                  8, // Un poco más alto
              padding: ResponsiveHelper.getCardPadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getScreenWidth(context) - 64,
                  ),
                  child: Text(
                    parking.name,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getHeadingFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
