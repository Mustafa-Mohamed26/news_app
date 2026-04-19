import 'package:flutter/material.dart';
import 'package:news_app/core/routes/app_routes.dart';
import 'package:news_app/presentation/home/home_screen.dart';

class AppRouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeRouteName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      );
    });
  }
}