plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin must be applied after Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")
    // Firebase plugins (Google Services must be applied before Crashlytics)
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.example.simple_movie_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.simple_movie_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            // Enable Crashlytics in release builds
            firebaseCrashlytics {
                nativeSymbolUploadEnabled = true
                unstrippedNativeLibsDir = file("build/app/intermediates/merged_native_libs/release/out/lib")
            }
        }

        debug {
            // Optional: Disable mapping file upload in debug builds
            firebaseCrashlytics {
                mappingFileUploadEnabled = false
            }
        }
    }
}
flutter {
    source = "../.."
}
