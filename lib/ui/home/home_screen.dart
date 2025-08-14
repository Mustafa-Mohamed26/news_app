import 'package:flutter/material.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/model/category.dart';
import 'package:news_app/ui/home/category_details/category_details.dart';
import 'package:news_app/ui/home/category_fragment/category_fragment.dart';
import 'package:news_app/ui/home/drawer/home_drawer.dart';
import 'package:news_app/ui/home/search/all_articles_widget.dart';
import 'package:news_app/utils/app_colors.dart'; // Example: widget for showing all articles

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Category? selectedCategory;
  bool isSearching = false; // Tracks search mode
  String searchQuery = "";

  OutlineInputBorder buildDecorationBorder({required Color colorBorderSide}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(width: 1, color: colorBorderSide),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: Theme.of(
                  context,
                ).textTheme.labelLarge, 
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).indicatorColor,
                    size: 30,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchQuery = "";
                      isSearching = false;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).indicatorColor,
                      size: 24,
                    ),
                  ),
                  hintText: AppLocalizations.of(context)!.search,
                  hintStyle: Theme.of(context).textTheme.labelLarge,
                  enabledBorder: buildDecorationBorder(
                    colorBorderSide: Theme.of(context).indicatorColor,
                  ),
                  focusedBorder: buildDecorationBorder(
                    colorBorderSide: Theme.of(context).indicatorColor,
                  ),
                ),
              )
            : Text(
                selectedCategory == null
                    ? AppLocalizations.of(context)!.home
                    : selectedCategory!.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),

        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  selectedCategory = null; // Clear category selection
                  isSearching = true; // Already true, but keep for clarity
                });
              },
            ),
        ],
      ),
      drawer: isSearching
          ? null
          : HomeDrawer(onDrawerItemClick: onDrawerItemClick),
      body: isSearching
          ? AllArticlesWidget(
              searchQuery: searchQuery,
            ) // Show all articles & filter
          : selectedCategory == null
          ? CategoryFragment(onCategoryItemClick: onCategoryItemClick)
          : CategoryDetails(category: selectedCategory!),
    );
  }

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
