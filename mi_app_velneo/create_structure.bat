@echo off
echo 🚀 Creando estructura para APP DISTRITO MALLOS...

REM Crear toda la estructura de carpetas
mkdir lib\config 2>nul
mkdir lib\models 2>nul
mkdir lib\controllers 2>nul
mkdir lib\views\screens\auth 2>nul
mkdir lib\views\screens\home 2>nul
mkdir lib\views\screens\merchants 2>nul
mkdir lib\views\screens\profile 2>nul
mkdir lib\views\screens\points 2>nul
mkdir lib\views\screens\notifications 2>nul
mkdir lib\views\widgets\common 2>nul
mkdir lib\views\widgets\custom 2>nul
mkdir lib\services 2>nul
mkdir lib\utils 2>nul
mkdir assets\images 2>nul
mkdir assets\icons 2>nul

echo 📁 Creando archivos base...

REM Crear archivos vacíos
echo. > lib\config\routes.dart
echo. > lib\config\theme.dart
echo. > lib\config\constants.dart
echo. > lib\models\user_model.dart
echo. > lib\models\merchant_model.dart
echo. > lib\models\points_model.dart
echo. > lib\models\notification_model.dart
echo. > lib\services\api_service.dart
echo. > lib\utils\helpers.dart
echo. > lib\utils\validators.dart
echo. > lib\views\screens\auth\login_screen.dart
echo. > lib\views\screens\auth\register_screen.dart
echo. > lib\views\screens\home\home_screen.dart
echo. > lib\views\screens\merchants\merchants_screen.dart
echo. > lib\views\screens\profile\profile_screen.dart
echo. > lib\views\screens\points\points_screen.dart
echo. > lib\views\screens\notifications\notifications_screen.dart
echo. > lib\views\widgets\common\custom_button.dart
echo. > lib\views\widgets\common\custom_text_field.dart
echo. > lib\views\widgets\common\loading_widget.dart

echo ✅ Estructura base creada!
echo.
echo 📂 Estructura generada:
echo ├── lib/
echo │   ├── config/ (rutas, tema, constantes)
echo │   ├── models/ (modelos de datos)
echo │   ├── controllers/ (lógica de negocio)
echo │   ├── views/
echo │   │   ├── screens/ (pantallas por módulo)
echo │   │   └── widgets/ (componentes reutilizables)
echo │   ├── services/ (servicios API)
echo │   └── utils/ (utilidades)
echo └── assets/ (imágenes e iconos)
echo.
echo 🚀 Ahora copia el contenido de los archivos desde el siguiente paso!

pause