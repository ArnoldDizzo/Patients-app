# Patient Vitals App

A Flutter application for managing patient vital signs, built with Firebase integration.

## Features

- User authentication with Firebase
- Real-time vital signs monitoring
- Secure data storage
- Modern and intuitive UI
- Form validation
- Error handling

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Firebase account
- Android Studio / VS Code with Flutter extensions

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd patient-vitals-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
   - Enable Email/Password authentication in Firebase Console

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   └── vital_record.dart
├── screens/
│   ├── login_screen.dart
│   └── doctor_vitals_screen.dart
├── services/
│   ├── auth_service.dart
│   └── vital_service.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── vital_field.dart
    └── vital_card.dart
```

## Dependencies

- firebase_core: ^latest_version
- firebase_auth: ^latest_version
- cloud_firestore: ^latest_version
- flutter: ^latest_version

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
