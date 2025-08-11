import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  // Default theme mode
  // You can change this to your preferred default theme mode
  ThemeMode appTheme = ThemeMode.light;

  // Constructor to load the saved theme from preferences
  AppThemeProvider() {
    _loadThemeFromPrefs(); 
  }

  // Method to load the theme from shared preferences
  // If no theme is saved, it will use the default theme mode
  Future<void> _loadThemeFromPrefs() async {
    // Initialize SharedPreferences and get the saved theme mode
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the saved theme mode, if it exists
    // If 'isDarkMode' is not set, it defaults to false (light mode
    final isDark = prefs.getBool('isDarkMode') ?? false;
    // Set the appTheme based on the saved preference
    // If isDark is true, set appTheme to dark mode, otherwise light mode
    appTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Method to save the current theme mode to shared preferences
  // This will be called whenever the user changes the theme
  Future<void> _saveThemeToPrefs() async {
    // Initialize SharedPreferences and save the current theme mode
    // If appTheme is dark, save isDarkMode as true, otherwise false
    final prefs = await SharedPreferences.getInstance();
    // Save the current theme mode preference
    // This saves a boolean indicating whether the app is in dark mode
    prefs.setBool('isDarkMode', appTheme == ThemeMode.dark);
  }

  // Method to change the app theme
  // It updates the appTheme variable and saves the new theme mode to preferences
  void changeTheme(ThemeMode newThemeMode) {
    // If the new theme mode is the same as the current one, do nothing
    // This prevents unnecessary updates and saves
    if (appTheme == newThemeMode) return;
    appTheme = newThemeMode;
    // Save the new theme mode to preferences
    // This ensures that the user's theme preference is stored
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Method to check if the current theme is dark mode
  // It returns true if the app is in dark mode, otherwise false
  bool isDarkMode() {
    return appTheme == ThemeMode.dark;
  }
}
