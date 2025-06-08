import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/utils/validators.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

class ClubScreen extends StatefulWidget {
  const ClubScreen({super.key});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simular llamada a API
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '¡Tarjeta virtual solicitada con éxito! Recibirás confirmación por email.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );

        // Limpiar formulario
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Club EU MALLOS',
        showBackButton: true,
        showMenuButton: false,
        showFavoriteButton: false,
        showLogo: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ RESPONSIVE: Layout adaptativo para 3 tamaños
          final maxContentWidth = ResponsiveHelper.isDesktop(context)
              ? 600.0
              : double.infinity;

          return SingleChildScrollView(
            padding: ResponsiveHelper.getHorizontalPadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // ✅ Imagen de tarjeta responsive
                    _buildCardImage(context, constraints),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // ✅ Texto de bienvenida protegido
                    _buildWelcomeText(context),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // ✅ Descripción del formulario
                    _buildFormDescription(context),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // ✅ Formulario responsive
                    _buildForm(context),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // ✅ Información de beneficios
                    _buildBenefitsInfo(context),

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

  Widget _buildCardImage(BuildContext context, BoxConstraints constraints) {
    // ✅ Tamaño controlado de imagen - SIN INFINITY
    final imageHeight = ResponsiveHelper.isDesktop(context)
        ? 200.0
        : ResponsiveHelper.isTablet(context)
        ? 180.0
        : 160.0;

    final imageWidth = ResponsiveHelper.isDesktop(context)
        ? 400.0
        : constraints.maxWidth - 32; // Usar constrains en lugar de infinity

    return Container(
      width: imageWidth,
      height: imageHeight,
      constraints: BoxConstraints(maxWidth: imageWidth, maxHeight: imageHeight),
      child: ClubCard(width: imageWidth, height: imageHeight),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.getScreenWidth(context) - 32,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            fontSize: ResponsiveHelper.getBodyFontSize(context),
            color: Colors.grey.shade700,
            height: 1.5,
          ),
          children: const [
            TextSpan(text: 'Ola, benvido/a ao '),
            TextSpan(
              text: 'Club EU MALLOS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            TextSpan(
              text:
                  ', queres\ndisfrutar de promocións no teu comercio de\nbarrio e outras sorpresas e vantaxes do ',
            ),
            TextSpan(
              text: 'CCA\nDISTRITO MALLOS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            TextSpan(text: ' ?.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFormDescription(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.getScreenWidth(context) - 32,
      ),
      child: Text(
        'Rexístrate neste formulario para obter a túa tarxeta virtual EU MALLOS nos estabelecementos asociados para conseguilas. Ademáis podes estar ao día das NOVAS PROMOS no apartado de "Promocións".',
        style: TextStyle(
          fontSize: ResponsiveHelper.getBodyFontSize(context),
          color: Colors.grey.shade700,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: ResponsiveHelper.getCardElevation(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Título del formulario
            Container(
              width: double.infinity,
              height: ResponsiveHelper.getButtonHeight(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getButtonBorderRadius(context),
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Center(
                child: Text(
                  'Alta Tarxeta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getSubtitleFontSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

            // Ilustración placeholder
            Container(
              height: ResponsiveHelper.isDesktop(context) ? 120 : 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getCardBorderRadius(context),
                ),
                gradient: const LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.purple,
                    Colors.red,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.groups,
                  size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
                  color: Colors.white,
                ),
              ),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // ✅ Campos del formulario con mejor responsive
            _buildTextField(
              controller: _nameController,
              labelText: 'Nome',
              hintText: 'obligatorio',
              validator: (value) => Validators.validateRequired(value, 'Nome'),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'obligatorio',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

            _buildTextField(
              controller: _phoneController,
              labelText: 'Móbil',
              hintText: '',
              keyboardType: TextInputType.phone,
              validator: Validators.validatePhone,
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // ✅ Botón ENVIAR con tamaño fijo
            SizedBox(
              width: ResponsiveHelper.isDesktop(context) ? 250 : 200,
              height: ResponsiveHelper.getButtonHeight(context),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getButtonBorderRadius(context) * 2,
                    ),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'ENVIAR',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getHeadingFontSize(
                            context,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.getScreenWidth(context),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(fontSize: ResponsiveHelper.getBodyFontSize(context)),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.getBodyFontSize(context),
          ),
          hintStyle: TextStyle(
            fontSize: ResponsiveHelper.getCaptionFontSize(context),
          ),
          border: const UnderlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getSmallSpacing(context),
            horizontal: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitsInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unha vez que descargou a súa tarxeta virtual, terá as siguintes vantaxes:',
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

          _buildBenefitText(
            context,
            '• Pode acumular puntos nas súas compras nos/nos estabelecementos asociados que logo poderá cambiar polas gratificacións que cada estabelecemento ofreza non seu apartado tarxeta EU MALLOS.',
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.small),

          _buildBenefitText(
            context,
            '• Chegarán ao seu móbil as mensaxes coas campañas que se están a realizar na asociación DISTRITO MALLOS.',
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.small),

          _buildBenefitText(
            context,
            '• Recibirá unha mensaxe de que hai novas promocións para consultar na APP (sección \'Promocións\').',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: ResponsiveHelper.getCaptionFontSize(context),
        color: AppTheme.textSecondary,
        height: 1.4,
      ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}
