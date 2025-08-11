import 'package:flutter/material.dart';
import 'package:news_app/model/category.dart';
import 'package:news_app/ui/home/category_details/category_details.dart';
import 'package:news_app/ui/home/category_fragment/category_fragment.dart';
import 'package:news_app/ui/home/drawer/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedCategory == null ? 'Home' : selectedCategory!.title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      drawer: HomeDrawer(onDrawerItemClick: onDrawerItemClick),
      body: selectedCategory == null
          ? CategoryFragment(onCategoryItemClick: onCategoryItemClick)
          : CategoryDetails(category: selectedCategory!),
    );
  }

  Category? selectedCategory;

  void onCategoryItemClick(Category newSelectedCategory) {
    selectedCategory = newSelectedCategory;
    setState(() {});
  }

  void onDrawerItemClick() {
    selectedCategory = null;
    Navigator.pop(context);
    setState(() {});
  }
}
