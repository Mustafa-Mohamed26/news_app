import 'package:flutter/material.dart';
import 'package:news_app/model/category.dart';
import 'package:news_app/ui/home/category_fragment/widget/category_item.dart';

typedef OnCategoryItemClick = void Function(Category);
class CategoryFragment extends StatelessWidget {
  List<Category> categoriesList = [];
  OnCategoryItemClick onCategoryItemClick;
  CategoryFragment({super.key, required this.onCategoryItemClick});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    categoriesList = Category.getCategoriesList(true);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Good Morning\nHere is Some News For You',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: height * 0.02),
          Expanded(
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
        ],
      ),
    );
  }
}
