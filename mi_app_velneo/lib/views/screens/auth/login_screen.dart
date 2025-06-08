import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/utils/validators.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
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

        // Navegar al home después del login exitoso
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error en login: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _openPrivacyPolicy() async {
    Navigator.pushNamed(context, AppRoutes.privacy);
  }

  Future<void> _openContactForm() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'distritomallos@gmail.com',
      query: Uri.encodeQueryComponent(
        'subject=Consulta desde la App&body=Hola,\n\nMe gustaría hacer una consulta.\n\nGracias.',
      ),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se pudo abrir el cliente de correo');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir correo: ${e.toString()}'),
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
        title: 'Login Asociados',
        showBackButton: true,
        showMenuButton: false,
        showFavoriteButton: false,
        showLogo: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ✅ RESPONSIVE: Layout adaptativo para login
            final maxContentWidth = ResponsiveHelper.isDesktop(context)
                ? 500.0
                : double.infinity;

            return SingleChildScrollView(
              padding: ResponsiveHelper.getHorizontalPadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                        // ✅ Logo responsive
                        _buildLogo(context),

                        ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                        // ✅ Formulario de login
                        _buildLoginForm(context),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.large,
                        ),

                        // ✅ Botones de acción
                        _buildActionButtons(context),

                        ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                        // ✅ Enlaces del footer
                        _buildFooterLinks(context),

                        ResponsiveHelper.verticalSpace(
                          context,
                          SpacingSize.large,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    // ✅ Logo con tamaño controlado
    final logoHeight = ResponsiveHelper.isDesktop(context)
        ? 120.0
        : ResponsiveHelper.isTablet(context)
        ? 100.0
        : 80.0;

    return SizedBox(
      height: logoHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: ResponsiveHelper.getMenuButtonIconSize(context),
              ),
              Text(
                'eu',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getSubtitleFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            'mallos',
            style: TextStyle(
              fontSize: ResponsiveHelper.getTitleFontSize(context) * 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              height: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      children: [
        // ✅ Campo Email responsive
        _buildTextField(
          controller: _emailController,
          labelText: 'Email',
          hintText: 'Introduce tu email',
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
          prefixIcon: const Icon(Icons.email_outlined),
        ),

        ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

        // ✅ Campo Contraseña responsive
        _buildTextField(
          controller: _passwordController,
          labelText: 'Contraseña',
          hintText: 'Introduce tu contraseña',
          obscureText: !_isPasswordVisible,
          validator: Validators.validatePassword,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.getScreenWidth(context),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
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
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          contentPadding: ResponsiveHelper.getCardPadding(context),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // ✅ Botón INICIAR con tamaño fijo
        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.getButtonHeight(context),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getButtonBorderRadius(context),
                ),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'INICIAR',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getHeadingFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

        // ✅ Botón CANCELAR con tamaño fijo
        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.getButtonHeight(context),
          child: OutlinedButton(
            onPressed: () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getButtonBorderRadius(context),
                ),
              ),
            ),
            child: Text(
              'CANCELAR',
              style: TextStyle(
                fontSize: ResponsiveHelper.getHeadingFontSize(context),
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLinks(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
      ),
      child: Column(
        children: [
          // ✅ Enlace Política de Privacidad
          _buildLinkButton(
            context,
            icon: Icons.privacy_tip_outlined,
            text: 'Política de Privacidad',
            semanticsLabel: 'Ver política de privacidad',
            backgroundColor: Colors.blue.shade50,
            borderColor: Colors.blue.shade200,
            textColor: Colors.blue.shade700,
            onTap: _openPrivacyPolicy,
          ),

          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

          // ✅ Enlace Formulario de Contacto
          _buildLinkButton(
            context,
            icon: Icons.contact_mail_outlined,
            text: 'Formulario de Contacto',
            semanticsLabel: 'Enviar consulta por correo',
            backgroundColor: Colors.green.shade50,
            borderColor: Colors.green.shade200,
            textColor: Colors.green.shade700,
            onTap: _openContactForm,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String semanticsLabel,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getCardBorderRadius(context),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveHelper.getSmallSpacing(context),
              horizontal: ResponsiveHelper.getMediumSpacing(context),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getCardBorderRadius(context),
              ),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: ResponsiveHelper.getCaptionFontSize(context) + 4,
                ),
                ResponsiveHelper.horizontalSpace(context, SpacingSize.small),
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
