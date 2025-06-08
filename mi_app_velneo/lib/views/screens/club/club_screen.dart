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

      // Simular llamada a API (reemplazar con llamada real)
      await Future.delayed(const Duration(seconds: 2));

      // Verificar si el widget sigue montado antes de usar context
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
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

            // Imagen de la tarjeta real - OPTIMIZADA
            ClubCard(
              width: double.infinity,
              height: ResponsiveHelper.getContainerMinHeight(context),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // Texto de bienvenida - RESPONSIVO
            Padding(
              padding: ResponsiveHelper.getHorizontalPadding(context),
              child: RichText(
                textAlign: TextAlign.center,
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
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // Texto del formulario - RESPONSIVO
            Padding(
              padding: ResponsiveHelper.getHorizontalPadding(context),
              child: Text(
                'Rexístrate neste formulario para obter a túa tarxeta virtual EU MALLOS nos estabelecementos asociados para conseguilas. Ademáis podes estar ao día das NOVAS PROMOS no apartado de "Promocións".',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getBodyFontSize(context),
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // Formulario con padding responsivo
            Container(
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
                    offset: const Offset(0, 5),
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
                            fontSize: ResponsiveHelper.getSubtitleFontSize(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // Ilustración de personas
                    Container(
                      height:
                          ResponsiveHelper.getContainerMinHeight(context) * 0.6,
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
                          size:
                              ResponsiveHelper.getMenuButtonIconSize(context) *
                              1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // Campo Nome
                    TextFormField(
                      controller: _nameController,
                      validator: (value) =>
                          Validators.validateRequired(value, 'Nome'),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        hintText: 'obligatorio',
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.getBodyFontSize(context),
                        ),
                        hintStyle: TextStyle(
                          fontSize: ResponsiveHelper.getCaptionFontSize(
                            context,
                          ),
                        ),
                        border: const UnderlineInputBorder(),
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // Campo Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'obligatorio',
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.getBodyFontSize(context),
                        ),
                        hintStyle: TextStyle(
                          fontSize: ResponsiveHelper.getCaptionFontSize(
                            context,
                          ),
                        ),
                        border: const UnderlineInputBorder(),
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // Campo Móbil
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Móbil',
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.getBodyFontSize(context),
                        ),
                        border: const UnderlineInputBorder(),
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // Botón ENVIAR - Altura responsiva
                    SizedBox(
                      width: 200,
                      height: ResponsiveHelper.getButtonHeight(context),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getButtonBorderRadius(context) *
                                  2,
                            ),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'ENVIAR',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getBodyFontSize(
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
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // Información de beneficios
            Container(
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

                  Text(
                    '• Pode acumular puntos nas súas compras nos/nos estabelecementos asociados que logo poderá cambiar polas gratificacións que cada estabelecemento ofreza non seu apartado tarxeta EU MALLOS.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                  Text(
                    '• Chegarán ao seu móbil as mensaxes coas campañas que se están a realizar na asociación DISTRITO MALLOS.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  ResponsiveHelper.verticalSpace(context, SpacingSize.small),

                  Text(
                    '• Recibirá unha mensaxe de que hai novas promocións para consultar na APP (sección \'Promocións\').',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
          ],
        ),
      ),
    );
  }
}
