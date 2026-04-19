import 'package:flutter/material.dart';
import 'package:news_app/core/l10n/app_localizations.dart';
import 'package:news_app/api/model/category.dart';
import 'package:news_app/core/providers/app_theme_provider.dart';
import 'package:news_app/presentation/home/category_fragment/widget/category_item.dart';
import 'package:provider/provider.dart';

/// A UI component that displays a selectable list of news categories 
/// (e.g., Sports, Business, Technology) to the user.
typedef OnCategoryItemClick = void Function(Category);
class CategoryFragment extends StatelessWidget {
  final OnCategoryItemClick onCategoryItemClick;
  const CategoryFragment({super.key, required this.onCategoryItemClick});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
        var themeProvider = Provider.of<AppThemeProvider>(context);

    List<Category> categoriesList = Category.getCategoriesList(themeProvider.isDarkMode());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.greetingNews,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onCategoryItemClick(categoriesList[index]);
                    },
                    child: CategoryItem(
                      category: categoriesList[index],
                      index: index,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: height * 0.02);
                },
                itemCount: categoriesList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
