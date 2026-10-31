# Google Play Policy Compliance — Step-by-Step Implementation Plan
**Project:** eResto Digi Menu (`eresto_menu`)  
**Package:** `in.eresto.digimenu`  
**Target Android Version:** Android 15 (API 35)  
**Document Version:** 1.0  
**Date:** October 2026  

---

## 📌 Executive Summary of Clarifications

### 1. Account Deletion Policy (Enterprise / No In-App Registration)
* **Status:** Users **cannot** register or create accounts inside the app. Accounts are pre-provisioned by restaurant administrators or the eResto web portal.
* **Google Play Policy Exemption:** If an app does not provide in-app user account creation, it is **exempt** from implementing an automated in-app account deletion mechanism.
* **Play Console Action:** In the *Data Safety* questionnaire under *"Does your app allow users to create an account?"*, select **"No"**.
* **Required Code Clean-Up:** The misleading `"Register"` button on `login_screen.dart` currently does nothing (`onTap: () {}`). It must be removed so Google Play reviewers do not mistake the app for a self-service registration app or reject it for broken functionality.

### 2. Photo & Video Access (`READ_MEDIA_IMAGES`)
* **Status:** The app only allows picking and cropping photos for food menu items and restaurant banners.
* **Technical Reality:** Modern Flutter (`image_picker: ^1.1.2`) uses the **Android System Photo Picker** (`PickVisualMedia`).
* **Google Play Rule:** The Photo Picker grants secure temporary access to selected files and **requires ZERO permissions** in `AndroidManifest.xml`.
* **Resolution:** Removing `READ_MEDIA_IMAGES` and `READ_EXTERNAL_STORAGE` will **NOT** break image picking, changing, cropping, or uploading. It is safe and required to remove them.

---

## 🗺️ Implementation Roadmap

```
[Phase 1: Manifest & Permissions] ──▶ [Phase 2: Gradle & Keystore]
                │                                    │
                ▼                                    ▼
[Phase 3: Login Screen Cleanup]   ──▶ [Phase 4: Profile Legal Card]
                                                     │
                                                     ▼
                                      [Phase 5: Release Verification]
```

---

## 🛠️ Phase 1: Android Manifest & Permissions Cleanup

### Target File: `android/app/src/main/AndroidManifest.xml`

### Objectives:
1. Remove `READ_MEDIA_IMAGES`, `READ_EXTERNAL_STORAGE`, and `WRITE_EXTERNAL_STORAGE`.
2. Remove deprecated `android:requestLegacyExternalStorage="true"`.
3. Add `<uses-feature android:name="android.hardware.camera" android:required="false" />` so POS tablets without cameras are supported.
4. Set `android:usesCleartextTraffic="false"` (enforcing secure HTTPS traffic).

### Planned Changes (Diff Preview):
```xml
@@ -6,15 +6,13 @@
-    <!-- Camera & Storage Permissions (for QR Scan & Image Uploads) -->
-    <uses-permission android:name="android.permission.CAMERA" />
-    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
-    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
-    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
+    <!-- Hardware Features (Optional so non-camera tablets/terminals can install) -->
+    <uses-feature android:name="android.hardware.camera" android:required="false" />
+    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />

     <application
         android:label="Digi Menu"
         android:name="${applicationName}"
         android:icon="@mipmap/ic_launcher"
-        android:usesCleartextTraffic="true"
-        android:requestLegacyExternalStorage="true"
+        android:usesCleartextTraffic="false"
         android:enableOnBackInvokedCallback="true">
```

---

## 🛠️ Phase 2: Gradle Versioning & Keystore Signing Setup

### Target File: `android/app/build.gradle.kts`

### Objectives:
1. Dynamically read `versionCode` and `versionName` from Flutter instead of hardcoding `1` and `"1.0.0"`.
2. Configure a release signing block with `key.properties` so builds are not signed with `debug.keystore`.

### Planned Changes (Diff Preview):
```kotlin
@@ -26,8 +26,8 @@
     defaultConfig {
         applicationId = "in.eresto.eresto_menu"
         minSdk = 21
         targetSdk = 35
-        versionCode = 1
-        versionName = "1.0.0"
+        versionCode = flutter.versionCode
+        versionName = flutter.versionName
         testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
     }

@@ -36,7 +36,11 @@
         debug {
             signingConfig = signingConfigs.getByName("debug")
         }
         release {
-            signingConfig = signingConfigs.getByName("debug")
+            // Will load from key.properties when present, fallback to debug for dev testing
+            signingConfig = signingConfigs.findByName("release") ?: signingConfigs.getByName("debug")
             isMinifyEnabled = false
             isShrinkResources = false
         }
     }
```

### Keystore Template: `android/key.properties.example`
Create an example template file for the team to configure their production upload key:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

---

## 🛠️ Phase 3: Login Screen Policy & UX Refinements

### Target File: `lib/features/auth/presentation/views/login_screen.dart`

### Objectives:
1. **Remove `"Register"`**: Prevent Play Store reviewer rejections for broken buttons and false account creation assumptions.
2. **Make `"Forgot Your Password?"` Functional**: Show an informative modal dialog directing the user to their restaurant administrator or eResto support.
3. **Add Legal Footer**: Include a prominent Privacy Policy and Terms of Service notice.

### Planned Code Design:
```dart
// 1. Password Assistance Dialog
void _showPasswordHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Password Assistance"),
      content: const Text(
        "Digi Menu terminal credentials are managed by your restaurant administrator.\n\n"
        "Please contact your store manager or reach out to eResto Support at support@eresto.in.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

// 2. In-App Legal Footer
Widget _buildLegalFooter(BuildContext context) {
  return Text.rich(
    TextSpan(
      text: "By signing in, you agree to eResto's ",
      style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF9CA3AF)),
      children: [
        TextSpan(
          text: "Terms",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary),
          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl("https://eresto.in/terms"),
        ),
        const TextSpan(text: " and "),
        TextSpan(
          text: "Privacy Policy",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary),
          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl("https://eresto.in/privacy-policy"),
        ),
      ],
    ),
    textAlign: TextAlign.center,
  );
}
```

---

## 🛠️ Phase 4: Profile Screen Legal & Enterprise Information

### Target File: `lib/features/profile/presentation/views/profile_screen.dart`

### Objectives:
1. Add a dedicated **"Legal & Support"** card in the Profile Screen containing:
   - **Privacy Policy**: Opens `https://eresto.in/privacy-policy` using `url_launcher`.
   - **Terms & Conditions**: Opens `https://eresto.in/terms`.
   - **App Version & Build**: Displays `v1.1.4 (Build 10)`.
2. Add an **Enterprise Account Data Note**:
   - Informs users: *"Station account & data lifecycle is managed by your restaurant enterprise admin. To request station deactivation or data removal, contact support@eresto.in."*

### Planned UI Component:
```dart
Widget _buildLegalSupportCard(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    padding: EdgeInsets.all(16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(icon: Icons.gavel_rounded, title: "Legal & Compliance"),
        const Divider(height: 1, color: Color(0xFFF3F4F6)),
        SizedBox(height: 12.h),
        _buildActionTile(
          icon: Icons.privacy_tip_outlined,
          title: "Privacy Policy",
          subtitle: "How your restaurant and station data is protected",
          onTap: () => launchUrl(Uri.parse("https://eresto.in/privacy-policy")),
        ),
        _buildActionTile(
          icon: Icons.description_outlined,
          title: "Terms of Service",
          subtitle: "End User License Agreement & Terms",
          onTap: () => launchUrl(Uri.parse("https://eresto.in/terms")),
        ),
        _buildActionTile(
          icon: Icons.delete_outline_rounded,
          title: "Account & Data Management",
          subtitle: "Enterprise data retention & deactivation info",
          onTap: () => _showEnterpriseDataInfoDialog(context),
        ),
      ],
    ),
  );
}
```

---

## 🛠️ Phase 5: Verification, Testing & Build Check

### 1. Functional Verification
* **Image Selection:** Test selecting images for menu items in `item_edit_sheet.dart` to verify the Android Photo Picker opens and functions without permissions.
* **Image Cropping:** Test `ImageCropperModal` in `gallery_selection_sheet.dart` to confirm in-memory image processing works properly.
* **Camera Selection:** Test selecting "Take with Camera" to confirm the system camera intent operates smoothly.
* **External Links:** Verify tapping Privacy Policy and Terms opens the browser smoothly.

### 2. Production Build Command
Run the release bundle generation:
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```
Confirm the output `.aab` file:
- Target SDK is 35.
- Version code reflects `pubspec.yaml` (e.g., `10`).
- No manifest merge errors or deprecated permission warnings occur.

---

## 📋 Phase 6: Google Play Console Questionnaire Guide

When filling out the questionnaire on the **Google Play Console**, follow these specific answers:

| Form Section | Question | Answer | Reason |
| :--- | :--- | :---: | :--- |
| **App Access** | Does your app require login credentials? | **Yes (Provide test credentials)** | Provide a test restaurant login ID, password, and station ID for Google Play testers. |
| **Ads** | Does your app contain ads? | **No** | App is ad-free B2B enterprise software. |
| **Target Audience** | Target age group? | **18 and over** | Avoids children/family policy compliance restrictions. |
| **Account Creation** | Does your app allow users to create an account? | **No** | B2B accounts are pre-provisioned; exempt from automated in-app account deletion requirements. |
| **Data Safety: Personal Info** | Name, Email, Phone Number | **Collected** | Collected for station session profile and authentication; encrypted in transit. |
| **Data Safety: Photos/Videos** | Photos | **Collected** | Menu item photos and restaurant banner uploads. |
| **Data Safety: Device IDs** | Device or other identifiers | **Collected** | Persistent app installation UUID (`DeviceService`) used for station session security. |
| **Data Safety: Diagnostics** | Crash logs | **Collected** | Collected via `firebase_crashlytics` for stability monitoring. |
| **Data Safety: Encryption** | Is all data encrypted in transit? | **Yes** | All endpoints transmit via TLS/HTTPS. |
| **Financial Features** | Does your app provide financial/banking services? | **No** | POS / Menu software; not a financial service app. |

---

## ✅ Readiness Checklist

- [ ] `READ_MEDIA_IMAGES` removed from `AndroidManifest.xml`
- [ ] Storage permissions removed from `AndroidManifest.xml`
- [ ] `android.hardware.camera` feature marked as `required="false"`
- [ ] `usesCleartextTraffic` set to `"false"`
- [ ] `versionCode` bound to `flutter.versionCode` in Gradle
- [ ] Release signing keystore configured
- [ ] "Register" button removed from login screen
- [ ] "Forgot Your Password?" wired to support dialog
- [ ] Privacy Policy links added to Login and Profile screens
- [ ] Test restaurant credentials prepared for Google reviewers
