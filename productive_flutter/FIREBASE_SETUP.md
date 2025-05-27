# Firebase Setup Guide

This guide will help you set up Firebase Authentication for the Productive Flutter app.

## Prerequisites

1. A Google account
2. Access to the [Firebase Console](https://console.firebase.google.com/)

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter your project name (e.g., "productive-app")
4. Choose whether to enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Authentication

1. In your Firebase project, click on "Authentication" in the left sidebar
2. Click "Get started"
3. Go to the "Sign-in method" tab
4. Enable "Email/Password" authentication:
   - Click on "Email/Password"
   - Toggle "Enable" to ON
   - Click "Save"

## Step 3: Add Android App

1. In the Firebase project overview, click the Android icon to add an Android app
2. Enter the Android package name: `com.erluxman.productive`
3. Enter an app nickname (optional): "Productive Flutter Android"
4. Enter the SHA-1 certificate fingerprint (optional for development)
5. Click "Register app"
6. Download the `google-services.json` file
7. **IMPORTANT**: Place the `google-services.json` file in the `android/app/` directory of your Flutter project

## Step 4: Add iOS App

1. In the Firebase project overview, click the iOS icon to add an iOS app
2. Enter the iOS bundle ID: `com.erluxman.productive`
3. Enter an app nickname (optional): "Productive Flutter iOS"
4. Enter the App Store ID (optional)
5. Click "Register app"
6. Download the `GoogleService-Info.plist` file
7. **IMPORTANT**: Place the `GoogleService-Info.plist` file in the `ios/Runner/` directory of your Flutter project

## Step 5: Configure iOS (Additional Steps)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Right-click on "Runner" in the project navigator
3. Select "Add Files to 'Runner'"
4. Navigate to and select the `GoogleService-Info.plist` file you downloaded
5. Make sure "Copy items if needed" is checked
6. Make sure "Runner" target is selected
7. Click "Add"

## Step 6: Update iOS Configuration

Add the following to your `ios/Runner/Info.plist` file inside the `<dict>` tag:

```xml
<!-- Add this for Firebase -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from your `GoogleService-Info.plist` file.

## Step 7: Test the Setup

1. Run `flutter clean`
2. Run `flutter pub get`
3. Run the app on a device or emulator
4. Try creating a new account or logging in

## File Locations Summary

After setup, you should have these files in place:

- `android/app/google-services.json` (Android configuration)
- `ios/Runner/GoogleService-Info.plist` (iOS configuration)

## Troubleshooting

### Common Issues:

1. **"google-services.json not found"**: Make sure the file is in `android/app/` directory
2. **"GoogleService-Info.plist not found"**: Make sure the file is in `ios/Runner/` directory and added to Xcode project
3. **Build errors**: Run `flutter clean` and `flutter pub get`
4. **iOS build issues**: Make sure the plist file is properly added to the Xcode project

### Firebase Console Settings:

- Make sure Email/Password authentication is enabled
- Check that your app's package name/bundle ID matches what you entered in Firebase
- Verify that the configuration files are downloaded from the correct project

## Security Notes

- Never commit your Firebase configuration files to public repositories
- Consider using different Firebase projects for development and production
- Set up proper security rules in Firebase Console

## Next Steps

Once Firebase is set up, the app will:

- Allow users to create accounts with email/password
- Enable login/logout functionality
- Store user data in Firestore
- Handle password reset emails

The authentication state is managed automatically, and users will be redirected to the appropriate screens based on their login status.
