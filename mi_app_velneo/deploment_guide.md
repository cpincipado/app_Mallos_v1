# 📘 Flutter Deployment Guide - Distrito Mallos App
## Guía Completa con Mejores Prácticas y Normas de Código

---

## 🏗️ **ARQUITECTURA Y CONFIGURACIÓN BASE**

### ✅ **Estructura de Proyecto OBLIGATORIA:**
```
mi_app_velneo/
├── android/                # Configuración Android
├── ios/                   # Configuración iOS  
├── web/                   # Configuración Web
├── lib/
│   ├── config/
│   │   ├── theme.dart          # Sistema de colores único
│   │   ├── routes.dart         # Navegación centralizada
│   │   └── constants.dart      # Constantes globales
│   ├── models/                 # Modelos de datos
│   ├── services/              # APIs y servicios
│   ├── utils/
│   │   ├── responsive_helper.dart  # Sistema responsive único
│   │   ├── validators.dart         # Validaciones
│   │   └── helpers.dart           # Utilidades generales
│   ├── views/
│   │   ├── screens/           # Pantallas principales
│   │   └── widgets/           # Componentes reutilizables
│   │       ├── common/        # Widgets comunes
│   │       └── specific/      # Widgets específicos
│   └── main.dart
├── assets/
│   ├── images/            # Imágenes de la app
│   └── icons/             # Iconos personalizados
├── pubspec.yaml           # Dependencias
└── analysis_options.yaml # Linting rules
```

### 🔧 **Dependencias ESTABLECIDAS:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0              # Requests HTTP
  shared_preferences: ^2.2.2 # Storage local
  provider: ^6.1.1          # State management
  cupertino_icons: ^1.0.2   # Iconos iOS
  url_launcher: ^6.2.5      # Enlaces externos

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0     # Análisis de código
```

---

## 🎯 **SISTEMA RESPONSIVE ÚNICO - REGLAS CRÍTICAS**

### **📐 Breakpoints ÚNICOS (NO CAMBIAR):**
```dart
// ✅ ÚNICO SISTEMA PERMITIDO
static const double mobileBreakpoint = 600;
static const double tabletBreakpoint = 900;

// Mobile: < 600px
// Tablet: 600px - 900px  
// Desktop: > 900px
```

### **📏 Tamaños CONTROLADOS:**
```dart
// ✅ BOTONES - ALTURA FIJA (NO CRECE)
static double getButtonHeight(BuildContext context) {
  return 48; // FIJO para todos los dispositivos
}

// ✅ ICONOS - TAMAÑO FIJO (NO CRECE)
static double getMenuButtonIconSize(BuildContext context) {
  return 28; // FIJO para evitar iconos gigantes
}

// ✅ CONTENEDORES - CONTROLADOS
static double getContainerMinHeight(BuildContext context) {
  if (isDesktop(context)) return 180;
  if (isTablet(context)) return 160;
  return 140; // Mobile
}
```

### **🎨 Typography ESCALADA:**
```dart
// ✅ SISTEMA DE FUENTES ÚNICO
static double getTitleFontSize(BuildContext context) {
  if (isDesktop(context)) return 28;
  if (isTablet(context)) return 24;
  return 20; // Mobile
}

static double getBodyFontSize(BuildContext context) {
  if (isDesktop(context)) return 16;
  if (isTablet(context)) return 15;
  return 14; // Mobile
}
```

### **📱 Espaciados SISTEMÁTICOS:**
```dart
// ✅ ESPACIADOS ÚNICOS
enum SpacingSize { xs, small, medium, large, xl }

static EdgeInsets getHorizontalPadding(BuildContext context) {
  if (isDesktop(context)) return const EdgeInsets.symmetric(horizontal: 32);
  if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 24);
  return const EdgeInsets.symmetric(horizontal: 16); // Mobile
}
```

---

## 🎨 **SISTEMA DE DISEÑO ÚNICO**

### **🌈 Colores OFICIALES (AppTheme):**
```dart
// ✅ COLORES ÚNICOS DE DISTRITO MALLOS
static const Color primaryColor = Color(0xFF2E7D32);    // Verde principal
static const Color secondaryColor = Color(0xFF4CAF50);  // Verde secundario
static const Color accentColor = Color(0xFFFF9800);     // Naranja
static const Color backgroundColor = Color(0xFFF5F5F5); // Fondo
static const Color cardColor = Colors.white;            // Tarjetas
static const Color textPrimary = Color(0xFF212121);     // Texto principal
static const Color textSecondary = Color(0xFF757575);   // Texto secundario

// ❌ PROHIBIDO usar otros colores
color: Colors.blue            // NO
color: Color(0xFF123456)     // NO
color: Colors.red            // NO (salvo casos muy específicos)
```

### **🎪 Tema ÚNICO:**
```dart
// ✅ TEMA CENTRALIZADO
static ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.green,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    
    cardTheme: const CardThemeData(
      color: cardColor,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
  );
}
```

---

## 🔒 **REGLAS DE CÓDIGO CRÍTICAS**

### **1. Verificación `mounted` OBLIGATORIA:**
```dart
// ✅ CORRECTO - SIEMPRE antes de usar context después de async
Future<void> _myAsyncFunction() async {
  setState(() { _isLoading = true; });
  
  try {
    await Future.delayed(Duration(seconds: 2));
    
    // ✅ CRÍTICO: Verificar mounted antes de usar context
    if (!mounted) return;
    
    setState(() { _isLoading = false; });
    Navigator.pushNamed(context, '/next');
  } catch (e) {
    if (mounted) {  // ✅ También en catch
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

// ❌ PELIGROSO - Sin verificación
await Future.delayed(Duration(seconds: 2));
Navigator.pushNamed(context, '/next'); // PUEDE CRASHEAR
```

### **2. Protección Anti-Overflow OBLIGATORIA:**
```dart
// ✅ TEXTO PROTEGIDO
ConstrainedBox(
  constraints: BoxConstraints(
    maxWidth: ResponsiveHelper.getScreenWidth(context) - 32,
  ),
  child: Text(
    'Texto largo que puede causar overflow...',
    style: TextStyle(
      fontSize: ResponsiveHelper.getBodyFontSize(context),
    ),
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  ),
)

// ✅ RICHTEXT PROTEGIDO
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: screenWidth - 32),
  child: RichText(
    textAlign: TextAlign.center,
    maxLines: 10,
    overflow: TextOverflow.ellipsis,
    text: TextSpan(/* contenido */),
  ),
)

// ❌ PELIGROSO - Sin protección
Text('Texto muy largo sin límites') // PUEDE CAUSAR OVERFLOW
```

### **3. Layouts Responsive OBLIGATORIOS:**
```dart
// ✅ LAYOUT ADAPTATIVO CORRECTO
LayoutBuilder(
  builder: (context, constraints) {
    final maxContentWidth = ResponsiveHelper.isDesktop(context) 
        ? 600.0 
        : double.infinity;
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: /* contenido */,
      ),
    );
  },
)

// ❌ PELIGROSO - Sin control de tamaño
Container(
  width: double.infinity,  // Sin ConstrainedBox
  child: /* contenido */,
)
```

### **4. Manejo de Errores ROBUSTO:**
```dart
// ✅ MANEJO COMPLETO DE ERRORES
Future<void> _sendEmail(BuildContext context) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'distritomallos@gmail.com',
    query: Uri.encodeQueryComponent(
      'subject=Solicitud&body=Contenido del mensaje',
    ),
  );

  try {
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('No se pudo abrir el cliente de correo');
    }
  } catch (e) {
    if (context.mounted) {  // ✅ Verificar mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

// ❌ PELIGROSO - Sin manejo de errores
await launchUrl(emailUri); // Puede crashear
```

### **5. Accesibilidad OBLIGATORIA:**
```dart
// ✅ BOTONES CON SEMANTICS
Semantics(
  label: 'Obtener tarjeta del club EU MALLOS',
  button: true,
  excludeSemantics: true,
  child: Material(
    child: InkWell(
      onTap: onTap,
      child: /* botón */,
    ),
  ),
)

// ✅ ICONBUTTONS CON TOOLTIP
IconButton(
  icon: Icon(Icons.menu, color: Colors.black),
  onPressed: () => Scaffold.of(context).openDrawer(),
  tooltip: 'Abrir menú de navegación',
)

// ✅ IMÁGENES CON SEMANTIC LABEL
Image.asset(
  'assets/images/distrito_mallos_logo.png',
  semanticLabel: 'Logo Distrito Mallos',
  errorBuilder: (context, error, stackTrace) {
    return fallbackWidget;
  },
)
```

---

## 🚨 **ANTI-PATRONES CRÍTICOS - NUNCA HACER**

### **❌ Sistemas Paralelos PROHIBIDOS:**
```dart
// ❌ NO crear helpers alternativos
class MyResponsiveHelper { }  // PROHIBIDO
class CustomSizes { }         // PROHIBIDO
class MyColors { }            // PROHIBIDO

// ❌ NO usar MediaQuery directamente (salvo casos muy específicos)
MediaQuery.of(context).size.width  // Usar ResponsiveHelper
```

### **❌ Tamaños Sin Control PROHIBIDOS:**
```dart
// ❌ NO permitir crecimiento ilimitado
Container(
  width: double.infinity,        // Sin ConstrainedBox
  height: constraints.maxHeight, // Sin límites máximos
)

// ❌ NO tamaños hardcoded
Container(width: 300, height: 200)  // PROHIBIDO
SizedBox(height: 50)                // Usar ResponsiveHelper
Padding(EdgeInsets.all(20))         // Usar ResponsiveHelper
```

### **❌ Navegación Insegura PROHIBIDA:**
```dart
// ❌ NO navegar sin verificar mounted
Navigator.push(context, route);     // PELIGROSO
Navigator.pop(context);             // PELIGROSO después de async

// ❌ NO usar context después de async sin verificar
await Future.delayed(Duration(seconds: 2));
Navigator.pop(context);  // CRASHEA si el widget se desmontó
```

### **❌ Texto Sin Protección PROHIBIDO:**
```dart
// ❌ NO texto sin límites
Text('Texto muy largo...')  // CAUSA OVERFLOW

// ❌ NO RichText sin protección  
RichText(text: TextSpan(/* contenido largo */))  // PELIGROSO

// ❌ NO formularios sin límites
Column(children: [
  TextFormField(), // Sin ConstrainedBox
  TextFormField(), // PUEDE CAUSAR OVERFLOW
])
```

---

## 🎯 **PATRONES OFICIALES APROBADOS**

### **1. Widget Responsivo Estándar:**
```dart
class MiWidget extends StatelessWidget {
  const MiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Mi Pantalla',
        showBackButton: true,
        showLogo: true,
      ),
      body: LayoutBuilder(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),
                    _buildContent(context),
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
}
```

### **2. Botón Responsivo Estándar:**
```dart
Widget _buildResponsiveButton(
  BuildContext context, {
  required String text,
  required VoidCallback onPressed,
  required String semanticsLabel,
  Color? backgroundColor,
  bool isLoading = false,
}) {
  return Semantics(
    label: semanticsLabel,
    button: true,
    child: SizedBox(
      width: double.infinity,
      height: ResponsiveHelper.getButtonHeight(context), // 48px fijo
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getButtonBorderRadius(context),
            ),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getHeadingFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    ),
  );
}
```

### **3. Campo de Texto Responsivo:**
```dart
Widget _buildTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String labelText,
  String? hintText,
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
      style: TextStyle(
        fontSize: ResponsiveHelper.getBodyFontSize(context),
      ),
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
```

### **4. Grid/Lista Responsiva Estándar:**
```dart
Widget _buildResponsiveGrid(BuildContext context) {
  return Padding(
    padding: ResponsiveHelper.getHorizontalPadding(context),
    child: LayoutBuilder(
      builder: (context, constraints) {
        // ✅ Cálculo de tamaños con límites
        final spacing = ResponsiveHelper.getMediumSpacing(context);
        final maxItemSize = ResponsiveHelper.isDesktop(context) ? 120.0 : 
                           ResponsiveHelper.isTablet(context) ? 100.0 : 90.0;
        
        final calculatedSize = (constraints.maxWidth - (spacing * 2)) / 3;
        final itemSize = calculatedSize > maxItemSize ? maxItemSize : calculatedSize;
        
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.isDesktop(context) ? 400 : double.infinity,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGridItem(context, itemSize),
                    _buildGridItem(context, itemSize),
                    _buildGridItem(context, itemSize),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
```

---

## 🔍 **VALIDACIONES Y TESTING**

### **📋 Validaciones OBLIGATORIAS:**
```dart
// ✅ VALIDADORES CENTRALIZADOS
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es obligatorio';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}).hasMatch(value)) {
      return 'Ingrese un email válido';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio';
    }
    if (!RegExp(r'^[0-9]{9}).hasMatch(value)) {
      return 'Ingrese un teléfono válido (9 dígitos)';
    }
    return null;
  }
}
```

### **🧪 Testing Responsive:**
```bash
# Probar en diferentes tamaños
flutter run -d chrome --web-renderer html

# Tamaños de prueba obligatorios:
# - 350px (móvil muy pequeño)
# - 400px (móvil pequeño)  
# - 600px (límite móvil/tablet)
# - 800px (tablet)
# - 1200px (desktop)
# - 1400px (desktop grande)
```

---

## 🚀 **COMANDOS Y DEPLOYMENT**

### **🔧 Comandos de Desarrollo:**
```bash
# Análisis obligatorio antes de commit
flutter analyze

# Tests obligatorios
flutter test

# Formateo de código
flutter format .

# Limpieza
flutter clean
flutter pub get

# Run en diferentes plataformas
flutter run -d chrome        # Web
flutter run -d android       # Android
flutter run -d ios          # iOS
```

### **📦 Build y Release:**
```bash
# Build Android
flutter build apk --release
flutter build appbundle --release

# Build iOS  
flutter build ios --release

# Build Web
flutter build web --release

# Análizar tamaño de bundle
flutter build apk --analyze-size
```

---

## 🤖 **NORMAS PARA IA Y ASISTENTES DE CÓDIGO**

### **🎯 REGLAS CRÍTICAS para IA:**

#### **✅ SIEMPRE hacer:**
1. **Usar ResponsiveHelper** para todos los tamaños y espaciados
2. **Proteger todo texto** con maxLines + overflow
3. **Verificar mounted** antes de cualquier navegación
4. **Usar colores de AppTheme** únicamente
5. **Añadir Semantics** a todos los elementos interactivos
6. **Usar try-catch** en todas las operaciones async
7. **Usar ConstrainedBox** en layouts flexibles
8. **Verificar mounted** en bloques catch

#### **❌ NUNCA hacer:**
1. **Crear sistemas paralelos** de responsive/colores/spacing
2. **Usar MediaQuery directo** (salvo casos muy específicos)
3. **Tamaños hardcoded** (width: 200, height: 100, etc.)
4. **Navegación sin verificar mounted**
5. **Texto sin protección de overflow**
6. **Colores que no sean de AppTheme**
7. **Operaciones async sin try-catch**
8. **Botones sin Semantics**

#### **🚨 Preguntar al usuario antes de:**
- Modificar breakpoints existentes
- Crear nuevos sistemas de colores
- Cambiar tamaños fijos (48px botones, 28px iconos)
- Modificar el sistema de espaciado
- Crear nuevos helpers o utilidades

#### **⚠️ Señales de alarma en el código:**
- Uso de MediaQuery.of(context).size
- Container con width/height hardcoded
- Navigator sin verificar mounted
- Text sin maxLines/overflow
- Colors.blue, Colors.red, etc. (no AppTheme)
- await sin try-catch
- InkWell/GestureDetector sin Semantics

---

## 🎉 **RESULTADO ESPERADO**

### **✅ Con estas normas la app tendrá:**
- **Responsive design profesional** en 3 breakpoints claramente definidos
- **Código consistente y mantenible** siguiendo patrones únicos
- **Accesibilidad completa** con Semantics y tooltips
- **Performance optimizada** con verificaciones mounted
- **UX uniforme** en todos los dispositivos
- **Robustez total** con manejo completo de errores
- **Escalabilidad** con sistemas centralizados

### **🎯 Métricas de calidad:**
- **0 overflow warnings** en cualquier tamaño de pantalla
- **0 navigation crashes** por widgets desmontados  
- **100% accesibilidad** en elementos interactivos
- **Consistencia visual** en todos los dispositivos
- **Código reutilizable** y fácil de mantener

**¡Siguiendo estas reglas religiosamente, el código será de nivel profesional y completamente robusto!** 🚀💪