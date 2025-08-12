import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/model/news_response.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/providers/app_language_provider.dart';
import 'package:news_app/ui/home/category_details/news/news_item.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class NewsWidget extends StatefulWidget {
  Source source;
  NewsWidget({super.key, required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);

    return FutureBuilder<NewsResponse?>(
      future: ApiManager.getNewsBySourceId(
        widget.source.id ?? "",
        languageProvider.appLanguage,
      ),
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greyColor),
          );
        }
        // error form client
        else if (snapshot.hasError) {
          return Column(
            children: [
              Text(
                'Something went wrong: ${snapshot.error}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  ApiManager.getNewsBySourceId(
                    widget.source.id ?? "",
                    languageProvider.appLanguage,
                  );
                  setState(() {}); // Refresh the widget to try again
                },
                child: Text(
                  'Try Again',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          );
        }

        // Server response in case of success or error
        if (snapshot.data?.status == 'error') {
          return Column(
            children: [
              Text(
                snapshot.data!.message!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  ApiManager.getNewsBySourceId(
                    widget.source.id ?? "",
                    languageProvider.appLanguage,
                  );
                  setState(() {}); // Refresh the widget to try again
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greyColor,
                ),
                child: Text(
                  'Try Again',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          );
        }

        // Display news articles
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
            return NewsItem(news: articles[index]);
          },
        );
      },
    );
  }
}
