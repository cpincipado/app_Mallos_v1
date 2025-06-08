/*
===========================================
DISTRITO MALLOS - GUÍAS DE DESARROLLO
===========================================

✅ COMPLETADO - RESPONSIVE DESIGN OPTIMIZATION:

1. IMPORTS - SIEMPRE RUTAS ABSOLUTAS:
   ✅ import 'package:mi_app_velneo/config/theme.dart';
   ❌ import '../../../config/theme.dart';

2. RESPONSIVE DESIGN - USAR SIEMPRE ResponsiveHelper:
   ✅ ResponsiveHelper.verticalSpace(context, SpacingSize.medium)
   ❌ const SizedBox(height: 20)
   
   ✅ ResponsiveHelper.getBodyFontSize(context)
   ❌ fontSize: 16

3. APPBAR - USAR SIEMPRE CustomAppBar:
   ✅ CustomAppBar(title: 'Mi Pantalla', showBackButton: true, showLogo: true)
   ❌ AppBar(title: Text('Mi Pantalla'))

4. CONTEXT SAFETY - VERIFICAR MOUNTED:
   ✅ if (!mounted) return;
   ❌ Usar context directamente después de await

5. DEPRECATED METHODS:
   ✅ Colors.black.withValues(alpha: 0.5)
   ❌ Colors.black.withOpacity(0.5)

6. SPACING CONSISTENTE:
   - SpacingSize.xs, small, medium, large, xl, xxl
   - Usar ResponsiveHelper.getScreenPadding() para pantallas
   - Usar ResponsiveHelper.getCardPadding() para containers

7. TYPOGRAPHY SYSTEM:
   - getTitleFontSize() - Títulos principales
   - getSubtitleFontSize() - Subtítulos  
   - getHeadingFontSize() - Encabezados
   - getBodyFontSize() - Texto normal
   - getCaptionFontSize() - Texto pequeño

8. COMPONENTES RESPONSIVE:
   - getButtonHeight() - Altura botones
   - getContainerMinHeight() - Containers
   - getCardBorderRadius() - Bordes
   - getCardElevation() - Sombras

✅ PANTALLAS OPTIMIZADAS (SIN OVERFLOW):
- SplashScreen ✅ Centrado perfecto
- HomeScreen ✅ Scroll + componentes responsive
- NewsSection ✅ Altura adaptable
- MenuButtonsSection ✅ Grid controlado
- FooterSection ✅ Logos adaptativos
- LoginScreen ✅ Formulario responsive
- ClubScreen ✅ Formulario responsive
- AssociateScreen ✅ Contactos responsive
- PrivacyScreen ✅ Texto largo controlado

9. OVERFLOW PROTECTION:
   ✅ SingleChildScrollView en pantallas largas
   ✅ Flexible/Expanded para textos
   ✅ maxLines + TextOverflow.ellipsis
   ✅ constraints en lugar de height fijo
   ✅ LayoutBuilder para adaptación automática

10. PRÓXIMOS PROBLEMAS A RESOLVER:
    - Hardcoded strings (i18n)
    - Gestión de estado (Provider/Bloc)
    - API calls con cache
    - Testing implementación
    - Seguridad (tokens, cifrado)
*/
