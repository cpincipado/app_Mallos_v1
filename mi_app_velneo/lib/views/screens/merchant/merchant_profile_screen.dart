import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/models/sale_model.dart';
import 'package:mi_app_velneo/services/sales_service.dart'; // ✅ CORREGIDO: Usar SalesService
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

class MerchantProfileScreen extends StatefulWidget {
  const MerchantProfileScreen({super.key});

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  MerchantProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await SalesService.getMerchantProfile(); // ✅ CORREGIDO
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar el perfil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmDeactivateAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desactivar Cuenta'),
        content: const Text(
          '¿Estás seguro de que quieres desactivar tu cuenta?\n\n'
          'Podrás reactivarla contactando con el administrador.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deactivateAccount();
    }
  }

  Future<void> _deactivateAccount() async {
    try {
      final success = await SalesService.deactivateAccount(); // ✅ CORREGIDO

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta desactivada exitosamente'),
            backgroundColor: Colors.orange,
          ),
        );

        // Navegar de vuelta al login
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al desactivar cuenta: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profile == null) {
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
              'Error al cargar el perfil',
              style: TextStyle(
                fontSize: ResponsiveHelper.getBodyFontSize(context),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
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

                  // ✅ Imagen del comercio
                  _buildMerchantImage(),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                  // ✅ Información del comercio
                  _buildMerchantInfo(),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                  // ✅ Estadísticas
                  _buildStatsSection(),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                  // ✅ Botón eliminar cuenta
                  _buildDeactivateButton(),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMerchantImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.getCardBorderRadius(context),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _profile!.imageUrl != null
            ? OptimizedImage(
                assetPath: _profile!.imageUrl!,
                fit: BoxFit.cover,
                semanticsLabel: 'Imagen de ${_profile!.name}',
                fallback: _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            _profile!.name,
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
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

  Widget _buildMerchantInfo() {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: ResponsiveHelper.getCardElevation(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del comercio
          Text(
            _profile!.name,
            style: TextStyle(
              fontSize: ResponsiveHelper.getSubtitleFontSize(context),
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

          // Dirección
          _buildInfoRow(
            Icons.location_on_outlined,
            'Dirección',
            _profile!.address,
          ),

          if (_profile!.phone != null)
            _buildInfoRow(Icons.phone_outlined, 'Teléfono', _profile!.phone!),

          if (_profile!.email != null)
            _buildInfoRow(Icons.email_outlined, 'Email', _profile!.email!),

          if (_profile!.website != null)
            _buildInfoRow(Icons.language_outlined, 'Web', _profile!.website!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getSmallSpacing(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getCaptionFontSize(context) + 4,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaptionFontSize(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaptionFontSize(context),
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: ResponsiveHelper.getCardElevation(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título de estadísticas
          Text(
            'Estadísticas',
            style: TextStyle(
              fontSize: ResponsiveHelper.getHeadingFontSize(context),
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          ResponsiveHelper.verticalSpace(context, SpacingSize.large),

          // Grid de estadísticas
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '${_profile!.stats.totalSales}',
                  'Ventas',
                  Icons.shopping_cart_outlined,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  '${_profile!.stats.totalPoints}',
                  'Puntos',
                  Icons.stars_outlined,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  _profile!.stats.formattedTotalAmount,
                  'Importe',
                  Icons.euro_outlined,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 0.8,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getHeadingFontSize(context),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeactivateButton() {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveHelper.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: _confirmDeactivateAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getButtonBorderRadius(context),
            ),
          ),
        ),
        child: Text(
          'ELIMINAR CUENTA',
          style: TextStyle(
            fontSize: ResponsiveHelper.getHeadingFontSize(context),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
