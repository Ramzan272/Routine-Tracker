# 📱 Routine Tracker App 

A beautifully designed habit-tracking mobile application built with Flutter and powered by ObjectBox.
**Routine Tracker** helps users maintain daily consistency with two key routines:

- 🕋 **Quran Recitation**
- 🏋️ **Gym Workouts**

This app empowers users to **track**, **analyze**, and **stay motivated** through a minimal and intuitive interface.
## 🌟 Features

### ✅ Daily Habit Logging
Easily mark your daily Quran reading and gym session with just a tap.

### 📊 Visual Progress Dashboard
See your weekly progress through colorful, animated indicators.

### 📅 Historical Activity
Scroll through past logs to see your consistency over time.

### 🔐 Authentication
Simple and secure login with password recovery functionality.

### 🧭 Seamless Navigation
Bottom navigation bar for easy switching between Quran and Gym modules.

## 🖼️ Screenshots

<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/c7447691-403a-4a3c-a5c4-c95e3caf83ae" />
 Add these screenshots in the `assets/screenshots/` folder and update the image paths.

 <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/8796d7e8-87db-4a2f-91f0-4ee13dfb286d" />

 <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/d825b091-f5ff-4435-ba73-bae2aca605ed" />

 <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/c2759455-d36a-42e8-99ef-9fdaf2863464" />

 <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/c4e4cff9-29f9-465a-a235-da6c69faa23f" />

 <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/82533150-1eee-44f4-be62-9aa6bb73fd6b" />


## 🛠 Tech Stack

| Technology     | Role                                 |
|----------------|--------------------------------------|
| **Flutter**     | Cross-platform UI framework          |
| **Dart**        | Programming language                 |
| **ObjectBox**   | Local NoSQL database (fast & reactive) |
| **Provider** or **GetX** | State management             |
| **Material UI** | Design system and widgets            |

## 📂 Folder Structure ##

bash
/lib
 ┣ models/
 ┃ ┗ habit.dart
 ┣ screens/
 ┃ ┣ home_screen.dart
 ┃ ┣ login_screen.dart
 ┃ ┣ progress_screen.dart
 ┃ ┗ history_screen.dart
 ┣ widgets/
 ┃ ┗ habit_card.dart
 ┣ services/
 ┃ ┗ objectbox_service.dart
 ┣ viewmodels/
 ┃ ┗ habit_viewmodel.dart
 ┗ main.dart

## 🚀 Getting Started

### 📦 Prerequisites

* Flutter SDK (latest stable)
* Android Studio or VS Code
* ObjectBox Flutter CLI

### 🧪 Setup Steps

1. **Clone the repo**
bash
git clone https://github.com/yourusername/routine-tracker.git
cd routine-tracker


2. **Install dependencies**

bash
flutter pub get

3. **Build ObjectBox model (if applicable)**

`bash
flutter pub run build_runner build

4. **Run the app**

`bash
flutter run


## 🔐 Authentication Setup

* Email/password-based login
* Password reset via email

> Update Firebase config in `/android/app/google-services.json` if using Firebase.

## 💡 Future Enhancements

* 🔔 Daily notification reminders
* 📈 Monthly performance graph
* ☁️ Cloud sync (Firebase or Supabase)
* 🌙 Dark mode toggle
* 🎯 Custom habit categories


## 🧑‍💻 Author

**Ramzan Mustafa**
🛠 Flutter Developer | 💡 Habit Builder | 📚 Quran Enthusiast
📧 Email: \[[ramzanmustafa865@gmail.com)]
💼 LinkedIn: \[https://www.linkedin.com/feed/]

## 🤝 Contributing

Contributions are welcome!
Please fork this repo, make changes, and create a pull request.

1. Fork it
2. Create your feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Create a new Pull Request


## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙌 Acknowledgements

* [Flutter](https://flutter.dev/)
* [ObjectBox](https://objectbox.io/)
* [Material Design](https://m3.material.io/)

### ✅ Next Steps

If you want, I can also provide:

- The actual `main.dart`, `model`, `screen`, and `service` files for this full app.
- A `LICENSE` file.
- A `demo.mp4` or GIF section for showing the app.
- Dark mode support toggle.

Let me know, and I’ll generate the full project folder for you
