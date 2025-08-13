# 📰 Flutter News App

A clean and responsive **news application** built with **Flutter**, using the [NewsAPI.org](https://newsapi.org/) REST API to deliver real-time headlines and articles. Users can explore trending topics, search for specific news, and read stories from various categories through an intuitive interface.

---

## ✨ Features
- **Live Headlines** from [NewsAPI.org](https://newsapi.org/)
- **Category Filters**: Technology, Sports, Health, Business, Entertainment, Science
- **Search Articles** by keyword
- **Responsive UI** for Android, iOS, and Web
- **Pull-to-Refresh** for instant updates
- **Dark & Light Modes**

---

## 🛠️ Built With
- **Flutter** – Cross-platform framework
- **Dart** – App logic & UI
- **HTTP Package** – API calls
- **Provider** – State management
- **Cached Network Image** – Efficient image loading and caching
- **Google Fonts** – Custom typography
- **Get Time Ago** – Friendly time formatting
- **Shared Preferences** – Local storage
- **URL Launcher** – Open external links

---

## 📦 Setup & Installation

**1. Prerequisites**
- Install [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code
- API key from [NewsAPI.org](https://newsapi.org/register)

**2. Clone the Repository**
```bash
git clone https://github.com/your-username/flutter-news-app.git
cd flutter-news-app
```

**3. Install Dependencies**
```bash
flutter pub get
```

**4. Add Your API Key**
Create `lib/config/api_keys.dart`:
```dart
const String newsApiKey = "YOUR_NEWSAPI_KEY";
```
Replace with your key from [NewsAPI.org](https://newsapi.org/).

**5. Run the App**
```bash
flutter run
```

---

## 📷 Screenshots
| Home | Article | Search |


---

## 🗂️ Folder Structure
```
lib/
├── main.dart               # Entry point
├── config/                 # Keys & constants
├── models/                 # Article & source models
├── services/               # API calls
├── screens/                # UI screens
└── widgets/                # Reusable components
```

---

## 🔑 API Reference
Base URL:
```
https://newsapi.org/v2/
```
**Endpoints**
- Top Headlines: `/top-headlines?country=us&apiKey=YOUR_API_KEY`
- Search: `/everything?q=keyword&apiKey=YOUR_API_KEY`

Docs: [https://newsapi.org/docs](https://newsapi.org/docs)

---

## 📜 License
Licensed under the **MIT License**.

---

## 🙌 Acknowledgements
- [NewsAPI.org](https://newsapi.org/) for free news data
- Flutter team for the framework
