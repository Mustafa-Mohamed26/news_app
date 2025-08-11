import 'package:flutter/material.dart';
import 'package:news_app/model/category.dart';
import 'package:news_app/ui/home/category_fragment/widget/category_item.dart';

class CategoryFragment extends StatelessWidget {
  List<Category> categoriesList = [];
  CategoryFragment({super.key});

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
                return CategoryItem(
                  category: categoriesList[index],
                  index: index,
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
