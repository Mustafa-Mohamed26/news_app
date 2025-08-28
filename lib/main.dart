import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:news_app/di/di_injectable.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/providers/app_language_provider.dart';
import 'package:news_app/providers/app_theme_provider.dart';
import 'package:news_app/ui/home/home_screen.dart';
import 'package:news_app/utils/app_routes.dart';
import 'package:news_app/utils/app_theme.dart';
import 'package:news_app/utils/my_bloc_observer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(SourceResponseAdapter());
  Hive.registerAdapter(SourceAdapter());
  configureDependencies();  
  runApp(
    // Use MultiProvider to provide multiple ChangeNotifier providers to the widget tree
    // This allows different parts of the app to access shared data and state management
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (context) => AppThemeProvider()),
      ],
      // The MyApp widget is the root of the application
      // It takes a boolean parameter to determine whether to show the onboarding screen
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the AppLanguageProvider and AppThemeProvider using Provider.of
    // This allows the app to use the current language and theme settings
    var appLanguageProvider = Provider.of<AppLanguageProvider>(context);
    // Access the AppThemeProvider to get the current theme mode
    // This is used to apply the correct theme to the MaterialApp
    var appThemeProvider = Provider.of<AppThemeProvider>(context);

    // Return a MaterialApp widget that serves as the root of the application
    // It provides localization support, routing, theming, and other app-wide configurations
    return MaterialApp(
      // Use the generated AppLocalizations class to provide localized strings
      localizationsDelegates: AppLocalizations
          .localizationsDelegates, // Use the generated AppLocalizations class
      supportedLocales: AppLocalizations
          .supportedLocales, // List of supported locales for localization
      locale: Locale(
        appLanguageProvider.appLanguage,
      ), // Set the current locale based on the appLanguageProvider

      debugShowCheckedModeBanner:
          false, // Disable the debug banner in the top right corner of the app
      // Set the theme of the app based on the current theme mode from AppThemeProvider
      // This allows the app to switch between light and dark themes based on user preference
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appThemeProvider.appTheme,

      // Define the initial route of the app based on whether the user has seen the onboarding screen
      initialRoute: AppRoutes.homeRouteName,
      routes: {AppRoutes.homeRouteName: (context) => HomeScreen()},
    );
  }
}
