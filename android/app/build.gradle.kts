import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.sentriscloud.solux"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.sentriscloud.solux"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Release signing: configured via local key.properties (NOT committed) OR
        // CI-injected env vars (SOLUX_KEYSTORE_PATH / _PASSWORD / _KEY_ALIAS / _KEY_PASSWORD).
        // Falls back to debug keystore only in dev builds — release builds without a
        // properly-configured release keystore will fail with a clear error.
        create("release") {
            val keyPropsFile = rootProject.file("key.properties")
            if (keyPropsFile.exists()) {
                val keyProps = Properties().apply {
                    load(keyPropsFile.inputStream())
                }
                storeFile = file(keyProps.getProperty("storeFile") ?: "")
                storePassword = keyProps.getProperty("storePassword") ?: ""
                keyAlias = keyProps.getProperty("keyAlias") ?: ""
                keyPassword = keyProps.getProperty("keyPassword") ?: ""
            } else {
                System.getenv("SOLUX_KEYSTORE_PATH")?.let {
                    storeFile = file(it)
                    storePassword = System.getenv("SOLUX_KEYSTORE_PASSWORD") ?: ""
                    keyAlias = System.getenv("SOLUX_KEY_ALIAS") ?: ""
                    keyPassword = System.getenv("SOLUX_KEY_PASSWORD") ?: ""
                }
            }
        }
    }

    buildTypes {
        release {
            // Audit H2 (2026-05-07): release builds previously signed with the debug
            // keystore — anyone could resign the published APK and impersonate Solux.
            // Now signs with the release config (loaded from key.properties or
            // CI env vars). Build fails fast if neither is provided.
            signingConfig = signingConfigs.findByName("release")
                ?: throw GradleException("Release signing config not found. Provide " +
                    "key.properties OR set SOLUX_KEYSTORE_* env vars before building.")

            // Audit H3 (2026-05-07): R8 minify + resource shrinking. When the crypto
            // layer lands, an unminified release binary lets attackers read keystore
            // logic + signing flow trivially. Enabling R8 now (pre-crypto) so the
            // discipline is in place before any sensitive code lands.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
