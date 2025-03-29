# HeartBridge - Orphanage Management App

HeartBridge is a comprehensive orphanage management application designed to connect donors with orphanages, streamlining the donation process and improving orphanage management. The platform consists of two applications: 

- **HeartBridge Donor App:** For donors to contribute and support orphanages.
- **HeartBridge Admin Dashboard:** For orphanage admins to manage operations and donations.

---

## Features

### Donor App
- User registration and authentication using Firebase
- Browse and view orphanage details
- Donate through secure payment gateways
- View donation history and track progress
- Receive updates and notifications

### Admin Dashboard
- Manage orphanage profiles and information
- Track and manage donations
- Generate reports and analytics
- Approve and verify donations

---

## Tech Stack
- **Frontend:** Flutter
- **Backend:** Firebase Firestore
- **Authentication:** Firebase Auth
- **Payment Gateway:** Razorpay / Stripe (configurable)
- **Storage:** Firebase Storage

---

## Installation

### Prerequisites
- Flutter installed
- Android Studio or Visual Studio Code
- Firebase account with a project set up

### Steps
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/heartbridge.git
    cd heartbridge
    ```
2. Configure Firebase by adding your `google-services.json` file for Android and `GoogleService-Info.plist` for iOS.
3. Install dependencies:
    ```bash
    flutter pub get
    ```
4. Run the app:
    ```bash
    flutter run
    ```

---

## Firebase Configuration
1. Create a project in [Firebase Console](https://console.firebase.google.com/).
2. Enable Authentication and Firestore Database.
3. Download the `google-services.json` or `GoogleService-Info.plist`.
4. Add them to their respective directories: 
    - Android: `android/app/google-services.json`
    - iOS: `ios/Runner/GoogleService-Info.plist`

---

## Contributing
Contributions are welcome! Follow these steps to contribute:
1. Fork the repository
2. Create a new branch (`feature/your-feature-name`)
3. Commit your changes
4. Create a pull request

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

---

## Contact
For questions or suggestions, feel free to reach out to the project author:
- **Name:** Girinath S.
- **Email:** girinathselvaraj22@gmail.com
- **LinkedIn:** [Girinath S. on LinkedIn](https://www.linkedin.com/in/girinath-selvaraj22/)

