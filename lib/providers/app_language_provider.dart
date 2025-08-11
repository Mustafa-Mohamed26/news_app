import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageProvider extends ChangeNotifier {
  // Default language code
  // You can change this to your preferred default language code
  String appLanguage = "en"; 

  // Constructor to load the saved language from preferences
  AppLanguageProvider() {
    _loadLanguageFromPrefs();
  }

  // Method to load the language from shared preferences
  // If no language is saved, it will use the default language code
  Future<void> _loadLanguageFromPrefs() async {
    // Initialize SharedPreferences and get the saved language code
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the saved language code, if it exists
    final savedLang = prefs.getString('languageCode');
    if (savedLang != null) {
      appLanguage = savedLang;
      // Notify listeners to update the UI
      notifyListeners();
    }
  }

  // Method to save the selected language code to shared preferences
  // This will be called whenever the user changes the language
  Future<void> _saveLanguageToPrefs(String langCode) async {
    // Initialize SharedPreferences and save the language code
    final prefs = await SharedPreferences.getInstance();
    // Save the new language code 
    await prefs.setString('languageCode', langCode);
  }

  // Method to change the app language
  // It updates the appLanguage variable and saves the new language code to preferences
  void changeLanguage(String newLanguage) {
    // If the new language is the same as the current one, do nothing
    if (newLanguage == appLanguage) return;
    appLanguage = newLanguage;
    // Save the new language code to preferences
    _saveLanguageToPrefs(newLanguage); 
    notifyListeners(); 
  }
}
