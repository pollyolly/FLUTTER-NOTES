# Flutter-Notes
### Configuration Files
Android
```
app/src/main/AndroidManifest.xml
app/build.gradle
app/google-services.json
app/application-keystore.jks
android/build.gradle
android/key.properties
pubspec.yaml
```
IOS
```
ios/runner/AppDelegate.swift
```
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
### Generate keystore for Goole API in Windows
```
https://docs.flutter.dev/deployment/android
Terminal:
keytool -genkey -v -keystore F:\Desktop\dev-flutter-projects\imoney-saver-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
IMONEY_SAVER/android/key.properties
```
storePassword=
keyPassword=
keyAlias=upload
storeFile=imoney-saver-keystore.jks

//project/app/imoney-saver-keystore.jks
```
app/build.gradle
```
//Add Before android Block
def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

//Replace builTypes to this

signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }
   
   //You need to run
//Note This will remove flutter packages
flutter clean
//Reinstall the packages
flutter pub get
```
### Generate credentials in Firebase
google-services.json
```
Copy to project/android/app/google-services.json
```
project/android/build.gradle
```
buildscript {
  repositories {
    // Check that you have the following line (if not, add it):
    google()  // Google's Maven repository

  }
  dependencies {
  
    // Add this line
    classpath 'com.google.gms:google-services:4.3.12'

  }
}

allprojects {
  
  repositories {
    // Check that you have the following line (if not, add it):
    google()  // Google's Maven repository

  
  }
}
```
project/android/app/build.gradle
```
apply plugin: 'com.google.gms.google-services'

dependencies {
implementation platform('com.google.firebase:firebase-bom:29.0.0')
    implementation 'com.google.firebase:firebase-analytics'
}
```
### Generate SHA1 and SHA2
```
keytool -keystore path-to-debug-or-production-keystore -list -v
```
### Reinstall All Packages ###
```
$flutter clean
$flutter pub get
```
### Troubleshooting ###
Some runtime JAR files in the classpath have an incompatible version. Consider removing them from the classpath
```
https://flutterhq.com/questions-and-answers/1568/flutter-build-runtime-jar-files-in-the-classpath-should-have-the-same-version-these-files-were-found-in-the-classpath
```
Shader compilation error
```
https://stackoverflow.com/questions/58380329/flutter-1-9-d-skia-5106-shader-compilation-error
```
throw PlatformException(code: errorCode, message: errorMessage as String, details: errorDetails, stacktrace: errorStacktrace);
```
//Possible you overlook to set/use the released keystore (SHA1 or SHA256) in Firebase
//debug keystore is not released keystore 
//Check app/build.gradle if you are using the released / debug keystore
https://stackoverflow.com/questions/70230784/throw-platformexceptioncode-errorcode-message-errormessage-as-string-detail
```
### Helpful Links
```
Google Drive Api
https://www.technicalfeeder.com/2021/12/flutter-file-folder-search-with-google-drive-api/
```
