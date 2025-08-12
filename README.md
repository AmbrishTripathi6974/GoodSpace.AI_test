# 🌟 Codespace Test Assignment

![Flutter](https://img.shields.io/badge/Flutter-3.4.4-blue?style=flat-square&logo=flutter&logoColor=white)  
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)  
![Build](https://img.shields.io/badge/Build-Passing-brightgreen?style=flat-square)  

This repository contains the complete solution for the **Codespace Test assignment**, demonstrating best practices in **Flutter development**, state management with **BLoC**, clean architecture, and professional **UI design**.

---  

## ✨ Features
- **User Authentication**  
  Users can create accounts, log in, and log out securely using Firebase Authentication, which supports email/password login.

- **Data Storage with Firestore**  
  The app saves and retrieves user-related data in real time using Firebase Firestore, a cloud-hosted NoSQL database.

- **Responsive User Interface**  
  The UI adapts to different screen sizes, making it easy to use on phones, tablets, or desktops.

- **State Management with BLoC Pattern**  
  The app uses the BLoC (Business Logic Component) pattern to keep its state organized and maintainable, ensuring a smooth and predictable user experience.

- **Optimized for GitHub Codespaces**  
  The project is fully configured to be opened, edited, and run inside GitHub Codespaces, a cloud development environment that runs in your VS Code or Android Studio.


---  

## 🛠️ Tech Stack

| Aspect              | Technology           | Description                      |  
|---------------------|----------------------|----------------------------------|  
| **Framework**       | [Flutter](https://flutter.dev)   | Cross-platform mobile development. |  
| **Authentication**  | [Firebase](https://firebase.google.com/) | User login and sign-up management & Real-Time data. |  
| **State Management**| [Flutter BLoC](https://bloclibrary.dev/) | Simplified state handling.       |  
| **Networking**      | [Dio](https://pub.dev/packages/dio) | Robust HTTP client.             |  
| **Routing**         | [GoRouter](https://pub.dev/packages/go_router) | Dynamic navigation.             |  
| **Local Storage**   | [Shared Preferences](https://pub.dev/packages/shared_preferences) | Efficient lightweight storage.   |  

---  

## 🚀 Getting Started

### Prerequisites

Ensure the following are installed on your system:
- **Flutter SDK**: Version `>=3.4.4 <4.0.0`.
- **Dart SDK**.
- **Android/iOS Setup**: For Flutter development.

### Installation

1. **Clone the Repository**:
   ```bash  
   git clone https://github.com/AmbrishTripathi6974/GoodSpace.AI_test.git  
   cd GoodSpace.AI_test  
   ```  

2. **Install Dependencies**:
   ```bash  
   flutter pub get  
   ```  

3. **Set Up Environment Variables: Firebase**:  

   Install FlutterFire CLI globally if you haven’t yet:
   ```bash  
   dart pub global activate flutterfire_cli
   ```

   Run the FlutterFire configuration command in your Flutter project directory:
   ```bash  
   flutterfire configure
   ```  
   This command will guide you through selecting your Firebase project and platforms (**Android, iOS, web**). It will generate firebase_options.dart, which contains your Firebase config.

   Initialize Firebase in main.dart
   ```bash
   void main() async {WidgetsFlutterBinding.ensureInitialized(););
   ```
   
5. **Run the App**:
   ```bash  
   flutter run  
   ```  

---  

## 📦 Dependencies

A glimpse at the major dependencies:

| Dependency            | Version | Purpose                                  |  
|-----------------------|---------|------------------------------------------|  
| `flutter_bloc`        | ^8.1.6  | State management.                        |  
| `hydrated_bloc`       | ^9.1.5  | Persistent state management.             |  
| `dio`                 | ^5.7.0  | Advanced HTTP client.                    |  
| `go_router`           | ^14.6.1 | Simplified navigation management.        |  
| `hive`                | ^2.2.3  | Lightweight local database.              |  
| `supabase_flutter`    | ^1.2.0  | Authentication and backend integration.  |  

For a complete list, check out the [`pubspec.yaml`](./pubspec.yaml).

---  

## 📖 Project Structure

The project follows **clean architecture principles** to ensure scalability and maintainability:

```
lib/  
├── core/               # Core utilities and constants  
├── data/               # Data sources and models  
├── features/           # App features grouped by functionality  
├── presentation/       # UI layers (widgets and screens)  
└── main.dart           # App entry point  
```  

---  

## 🖥️ Screenshots

### Coming Soon

---  

## 🌐 Acumensa

This application is an intellectual property of **Acumensa** and is not open-source. Unauthorized duplication, sharing, or modification is prohibited.

---  

### 👥 Contributors

- **Project Owner**: Acumensa Team
- **Lead Developer**: Arya Pratap Singh | [Working Branch](https://github.com/AcumensaDev/MyWonderApp/tree/latest-release)

---  

Made with 💙 by **Acumensa**.  











