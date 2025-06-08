import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';

class AssociateScreen extends StatelessWidget {
  const AssociateScreen({super.key});

  // Función para enviar correo
  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'distritomallos@gmail.com',
      query:
          'subject=Solicitud de Asociación - Distrito Mallos&body=Hola,%0A%0AMe gustaría obtener más información sobre cómo asociarme a Distrito Mallos.%0A%0AGracias.',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'No se pudo abrir el cliente de correo';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al abrir el correo. Inténtalo más tarde.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Función para hacer llamada telefónica
  Future<void> _makePhoneCall(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '623744226');

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'No se pudo abrir la aplicación de teléfono';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al abrir la aplicación de teléfono'),
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
        title: 'Asóciate',
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
            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // Ilustración de profesionales - RESPONSIVE
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.getContainerMinHeight(context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getCardBorderRadius(context),
                  ),
                  color: Colors.grey.shade100,
                ),
                child: Icon(
                  Icons.group,
                  size: ResponsiveHelper.getMenuButtonIconSize(context) * 2,
                  color: Colors.grey,
                ),
              ),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // Texto principal - COMPLETAMENTE RESPONSIVE
            Padding(
              padding: ResponsiveHelper.getHorizontalPadding(context),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getBodyFontSize(context),
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                  children: const [
                    TextSpan(
                      text:
                          'Todos os profesionais temos cabida na\nAsociación ',
                    ),
                    TextSpan(
                      text: 'DISTRITO MALLOS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text:
                          '.\n\nSe desenvolves a túa actividade profesional ou tes a túa dirección fiscal no noso barrio, podes unirte e beneficiarte das vantaxes de ser asociado e de pertencer o ',
                    ),
                    TextSpan(
                      text: 'CCA DISTRITO MALLOS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

            // Botón ÚNETE - RESPONSIVE
            Container(
              width: double.infinity,
              height: ResponsiveHelper.getButtonHeight(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getButtonBorderRadius(context),
                ),
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.redAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: ResponsiveHelper.getCardElevation(context),
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getButtonBorderRadius(context),
                  ),
                  onTap: () => _sendEmail(context),
                  child: Center(
                    child: Text(
                      'ÚNETE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getSubtitleFontSize(context),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // Información de contacto - RESPONSIVE
            Column(
              children: [
                // Email clickeable - RESPONSIVE
                Container(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getScreenWidth(context) - 40,
                  ),
                  child: GestureDetector(
                    onTap: () => _sendEmail(context),
                    child: Container(
                      padding: ResponsiveHelper.getCardPadding(context)
                          .copyWith(
                            top: ResponsiveHelper.getSmallSpacing(context),
                            bottom: ResponsiveHelper.getSmallSpacing(context),
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
                            Icons.email_outlined,
                            color: Colors.blue.shade700,
                            size:
                                ResponsiveHelper.getMenuButtonIconSize(
                                  context,
                                ) *
                                0.6,
                          ),
                          ResponsiveHelper.horizontalSpace(
                            context,
                            SpacingSize.small,
                          ),
                          Flexible(
                            child: Text(
                              'distritomallos@gmail.com',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getBodyFontSize(
                                  context,
                                ),
                                color: Colors.blue.shade700,
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

                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                // Teléfono clickeable - RESPONSIVE
                Container(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getScreenWidth(context) - 40,
                  ),
                  child: GestureDetector(
                    onTap: () => _makePhoneCall(context),
                    child: Container(
                      padding: ResponsiveHelper.getCardPadding(context)
                          .copyWith(
                            top: ResponsiveHelper.getMediumSpacing(context),
                            bottom: ResponsiveHelper.getMediumSpacing(context),
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
                            Icons.phone_outlined,
                            color: Colors.green.shade700,
                            size:
                                ResponsiveHelper.getMenuButtonIconSize(
                                  context,
                                ) *
                                0.75,
                          ),
                          ResponsiveHelper.horizontalSpace(
                            context,
                            SpacingSize.small,
                          ),
                          Text(
                            '623 74 42 26',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getHeadingFontSize(
                                context,
                              ),
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
          ],
        ),
      ),
    );
  }
}
