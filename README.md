# Smart Insulin Application

## Overview

<p align="center">
  <img src="Logo.png" alt="Smart Insulin" width="300"/>
</p>

The Smart Insulin Application is a mobile platform developed using Flutter to aid individuals in managing their diabetes. It integrates various features, including:

* User authentication (sign-in/sign-up)
* Bluetooth connectivity for device communication
* Data monitoring and display
* Automated insulin dosing
* User profile management
* Scheduling and reminders
* Settings and account management
* A chat assistant

## Key Technologies

* Flutter: For cross-platform mobile development
* Firebase: For user authentication and data storage
* Flutter Blue Plus: For Bluetooth Low Energy (BLE) communication

## Project Structure

The project is organized as follows:

* `android/`: Android-specific build files and configurations
* `ios/`: iOS-specific build files and configurations
* `lib/`: Dart code for the Flutter application
    * `app.dart`: Main application widget
    * `controllers/`: Controllers for app logic (e.g., Bluetooth)
    * `models/`: Data models
    * `screens/`: UI screens for the application
    * `widgets/`: Reusable UI components
    * `routes/app_routes.dart`: Navigation routes
* `linux/`: Linux-specific build files
* `macos/`: macOS-specific build files
* `web/`: Web application files
* `windows/`: Windows-specific build files
* `test/`: Automated tests
* `AnnTraining/`: Python scripts for an artificial neural network

## Setup Instructions

1.  **Install Flutter:** Follow the official Flutter installation guide.
2.  **Set up Firebase:**
    * Create a Firebase project.
    * Enable the necessary Firebase services (Authentication, Firestore).
    * Download the `google-services.json` (for Android) and `FirebaseOptions.plist` (for iOS) files and place them in the correct project locations.
3.  **Clone the repository:** `git clone <repository_url>`
4.  **Install dependencies:** Run `flutter pub get` in the project root.
5.  **Configure Bluetooth (if needed):**
    * Ensure Bluetooth is enabled on your development machine.
    * Update the Bluetooth UUIDs in `lib/controllers/bluetooth_controller.dart` to match your device.
6.  **Run the application:** `flutter run`

## Testing

The project includes automated tests to ensure the quality and reliability of the application.

* Widget tests are located in the `test/` directory.
* A detailed test report for the `PodStatusScreen` widget can be found in `test/flutter_test_report.md`.

## Additional Notes

* This README provides a high-level overview of the project.
* For detailed information on specific features or implementation details, please refer to the code and inline documentation.
