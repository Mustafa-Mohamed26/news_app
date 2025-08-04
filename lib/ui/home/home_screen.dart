import 'package:flutter/material.dart';
import 'package:news_app/ui/home/category_details/category_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: Theme.of(context).textTheme.headlineLarge),
      ),

      body: CategoryDetails(),
    );
  }
}
