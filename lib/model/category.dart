import 'package:news_app/utils/app_assets.dart';

class Category {
  String id;
  String title;
  String image;

  Category({required this.id, required this.title, required this.image});

  static List<Category> getCategoriesList(bool isDark) {
    return [
      Category(
        id: 'general',
        title: 'General',
        image: isDark ? AppAssets.generalDark : AppAssets.generalLight,
      ),
      Category(
        id: 'business',
        title: 'Business',
        image: isDark ? AppAssets.busniessDark : AppAssets.businessLight,
      ),
      Category(
        id: 'sports',
        title: 'Sports',
        image: isDark ? AppAssets.sportDark : AppAssets.sportLight,
      ),
      Category(
        id: 'technology',
        title: 'Technology',
        image: isDark ? AppAssets.technologyDark : AppAssets.technologyLight,
      ),
      Category(
        id: 'entertainment',
        title: 'Entertainment',
        image: isDark
            ? AppAssets.entertainmentDark
            : AppAssets.entertainmentLight,
      ),
      Category(
        id: 'health',
        title: 'Health',
        image: isDark ? AppAssets.healthDark : AppAssets.healthLight,
      ),
      Category(
        id: 'science',
        title: 'Science',
        image: isDark ? AppAssets.scienceDark : AppAssets.scienceLight,
      ),
    ];
  }
}
