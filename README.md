# 🌟 Codespace Test Assignment

![Flutter](https://img.shields.io/badge/Flutter-3.4.4-blue?style=flat-square&logo=flutter&logoColor=white)  
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)  
![Build](https://img.shields.io/badge/Build-Passing-brightgreen?style=flat-square)  

This repository contains the complete solution for the **Codespace Test assignment**, demonstrating best practices in **Flutter development**, state management with **BLoC**, clean architecture, and professional **UI design**.

---  

## 🎨 Design Reference

Explore the meticulously crafted UI/UX on [Figma](https://www.figma.com/design/hiyr0iiTzdOCUlPDyr3XuS/%5BFor-review%5D-My-Wonder?node-id=5-2&t=4G6xKr5y4LSu9LUs-1).

---  

## ✨ Features

- **Seamless Authentication**: Powered by [Supabase](https://supabase.io/).
- **Modern State Management**: Leveraging the BLoC pattern for efficiency.
- **IoT Protocol Integration**: Supports **HTTPv2** for smooth device communication.
- **Error-Handling States**: Provides a resilient user experience.
- **Animations**: Stunning micro-interactions using **Lottie**.
- **Responsive UI**: Designed for exceptional usability across all device sizes.

---  

## 🛠️ Tech Stack

| Aspect              | Technology           | Description                      |  
|---------------------|----------------------|----------------------------------|  
| **Framework**       | [Flutter](https://flutter.dev)   | Cross-platform mobile development. |  
| **Authentication**  | [Supabase](https://supabase.io/) | User login and sign-up management. |  
| **State Management**| [Flutter BLoC](https://bloclibrary.dev/) | Simplified state handling.       |  
| **Networking**      | [Dio](https://pub.dev/packages/dio) | Robust HTTP client.             |  
| **Routing**         | [GoRouter](https://pub.dev/packages/go_router) | Dynamic navigation.             |  
| **Local Storage**   | [Hive](https://pub.dev/packages/hive) | Efficient lightweight storage.   |  

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
   git clone https://github.com/acumensa/my-wonder-app.git  
   cd my-wonder-app  
   ```  

2. **Install Dependencies**:
   ```bash  
   flutter pub get  
   ```  

3. **Set Up Environment Variables**:  
   Create a `.env` file in the root directory and add the following:
   ```env  
   SUPABASE_URL=https://your-supabase-url.supabase.co  
   SUPABASE_KEY=your-anon-or-service-key  
   ```  

4. **Run the App**:
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

