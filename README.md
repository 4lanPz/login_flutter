# Login y ubicación en Flutter

## Herramientas

- Visual Studio Code
- Flutter
- Android Studio
- Node
- Firebase

## Descargar paquetes flutter

Ejecutar el siguiente comando para poder descargar todo lo necesario del proyecto

```bash
flutter pub get  
```

## Variables

Ejecutar el siguiente comando para poder generar sus variables de Firebase

```bash
flutter pub global activate flutterfire_cli
flutterfire configure    
```

Para firebase hosting ejecutar
```bash
flutter build web
```
Pasar los datos dentro de la carpeta web a la carpeta public que se debe haber creado

```bash
npm install -g firebase-tools
npx firebase login
npx firebase hosting init
```
luego que ya esté todo completo ejecutar y le da un link para el deploy web

```bash
npx firebase deploy
```

## Generar APK
Ejecutar el siguiente comando y buscar la APK generada en build/app/flutter-apk/
```bash
flutter build apk --split-per-abi
```






