import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/model/news_response.dart';
import 'package:news_app/providers/app_language_provider.dart';
import 'package:news_app/ui/home/category_details/news/news_details_bottom_sheet.dart';
import 'package:news_app/ui/home/category_details/news/news_item.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class AllArticlesWidget extends StatelessWidget {
  final String searchQuery;
  const AllArticlesWidget({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);

    return FutureBuilder<NewsResponse?>(
      future: ApiManager.getNewsBySourceId(
        sourceId: "", // Empty means no specific source → get all
        language: languageProvider.appLanguage,
        query: searchQuery.isEmpty ? null : searchQuery,
      ),
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greyColor),
          );
        }

        // Articles
        var articles = snapshot.data?.articles ?? [];

        if (articles.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noArticles,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          );
        }

        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            var article = articles[index];
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return NewsDetailsBottomSheet(article: article);
                  },
                );
              },
              child: NewsItem(news: article),
            );
          },
        );
      },
    );
  }
}
