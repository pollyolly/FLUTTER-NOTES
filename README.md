# Flutter-Notes
### Installation
```
https://www.youtube.com/watch?v=tun0HUHaDuE
```
### Commands
```
flutter doctor
```
### VS Code
To create new Flutter app in Vs Code
```
Hold Ctrl + Hold Shift + P 
```
### VS Code Terminal Intallation Flutter packages
```
flutter pub add sqflite 
flutter pub add path
```
### Generate Release apk
```
flutter build apk --split-per-abi

Location:
[project]/build/app/outputs/apk/release/app-armeabi-v7a-release.apk
[project]/build/app/outputs/apk/release/app-arm64-v8a-release.apk
[project]/build/app/outputs/apk/release/app-x86_64-release.apk
```
### Test SQLite 
```
https://www.sqlitetutorial.net/tryit/
```
### Generate keystore in Windows
```
https://docs.flutter.dev/deployment/android
Terminal:
keytool -genkey -v -keystore F:\Desktop\dev-flutter-projects\imoney-saver-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
android/key.properties
```
storePassword=1234demo
keyPassword=1234demo
keyAlias=upload
storeFile=F:\Desktop\dev-flutter-projects\imoney-saver-keystore.jks
```
