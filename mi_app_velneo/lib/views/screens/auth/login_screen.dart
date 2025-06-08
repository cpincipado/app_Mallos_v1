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

      // Simular llamada a API (reemplazar con llamada real)
      await Future.delayed(const Duration(seconds: 2));

      // Verificar si el widget sigue montado antes de usar context
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Navegar al home después del login exitoso
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Future<void> _openPrivacyPolicy() async {
    Navigator.pushNamed(context, AppRoutes.privacy);
  }

  Future<void> _openContactForm() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'distritomallos@gmail.com',
      query:
          'subject=Consulta desde la App&body=Hola,%0A%0AMe gustaría hacer una consulta.%0A%0AGracias.',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'No se pudo abrir el cliente de correo';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el cliente de correo'),
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
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getScreenPadding(context),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                // Logo eu mallos - RESPONSIVE
                SizedBox(
                  height: ResponsiveHelper.getContainerMinHeight(context) * 0.6,
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
                            size: ResponsiveHelper.getMenuButtonIconSize(
                              context,
                            ),
                          ),
                          Text(
                            'eu',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getSubtitleFontSize(
                                context,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'mallos',
                        style: TextStyle(
                          fontSize:
                              ResponsiveHelper.getTitleFontSize(context) * 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                // Campo Email - RESPONSIVE
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getBodyFontSize(context),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Introduce tu email',
                    labelStyle: TextStyle(
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                    ),
                    hintStyle: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: const OutlineInputBorder(),
                  ),
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                // Campo Contraseña - RESPONSIVE
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  validator: Validators.validatePassword,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getBodyFontSize(context),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Introduce tu contraseña',
                    labelStyle: TextStyle(
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                    ),
                    hintStyle: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                // Botón INICIAR - RESPONSIVE
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
                              fontSize: ResponsiveHelper.getHeadingFontSize(
                                context,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                // Botón CANCELAR - RESPONSIVE
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveHelper.getButtonHeight(context),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
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

                ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                // Enlaces del footer - RESPONSIVE
                Container(
                  padding: ResponsiveHelper.getCardPadding(context),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getCardBorderRadius(context),
                    ),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _openPrivacyPolicy,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.getSmallSpacing(context),
                            horizontal: ResponsiveHelper.getMediumSpacing(
                              context,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getCardBorderRadius(context),
                            ),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.privacy_tip_outlined,
                                color: Colors.blue.shade700,
                                size:
                                    ResponsiveHelper.getCaptionFontSize(
                                      context,
                                    ) +
                                    4,
                              ),
                              ResponsiveHelper.horizontalSpace(
                                context,
                                SpacingSize.small,
                              ),
                              Text(
                                'Política de Privacidad',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getBodyFontSize(
                                    context,
                                  ),
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ResponsiveHelper.verticalSpace(
                        context,
                        SpacingSize.medium,
                      ),

                      GestureDetector(
                        onTap: _openContactForm,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.getSmallSpacing(context),
                            horizontal: ResponsiveHelper.getMediumSpacing(
                              context,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getCardBorderRadius(context),
                            ),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.contact_mail_outlined,
                                color: Colors.green.shade700,
                                size:
                                    ResponsiveHelper.getCaptionFontSize(
                                      context,
                                    ) +
                                    4,
                              ),
                              ResponsiveHelper.horizontalSpace(
                                context,
                                SpacingSize.small,
                              ),
                              Text(
                                'Formulario de Contacto',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getBodyFontSize(
                                    context,
                                  ),
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.large),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
