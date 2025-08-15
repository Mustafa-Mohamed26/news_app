import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/model/news_response.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/providers/app_language_provider.dart';
import 'package:news_app/ui/home/category_details/news/news_details_bottom_sheet.dart';
import 'package:news_app/ui/home/category_details/news/news_item.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class NewsWidget extends StatefulWidget {
  final Source source;
  const NewsWidget({super.key, required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final ScrollController scrollController =
      ScrollController(); // Scroll controller to detect when reaching the bottom
  final List<Articles> articles = []; // List to store fetched articles
  int currentPage = 1; // Current pagination page
  bool isLoading = false; // To prevent multiple requests at the same time
  bool hasMore = true; // Whether more data is available to load
  bool showLoadingText =
      false; // Whether to show the "loading" text after a short delay
  String? errorMessage; // To store any error message

  @override
  void initState() {
    super.initState();
    fetchNews(); // Load the first page initially

    // Add scroll listener for infinite scrolling
    scrollController.addListener(() {
      // If the user is close to the bottom (200px), not currently loading, and more data exists
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        fetchNews();
      }
    });
  }

  @override
  void didUpdateWidget(covariant NewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the source changes, reset the list and reload
    if (oldWidget.source.id != widget.source.id) {
      currentPage = 1;
      articles.clear();
      hasMore = true;
      fetchNews();
    }
  }

  Future<void> fetchNews() async {
    if (isLoading) return; // Prevent duplicate requests

    setState(() {
      isLoading = true;
      showLoadingText = false;
      errorMessage = null;
    });

    // Delay showing the loading text for better UX
    Timer(const Duration(milliseconds: 300), () {
      if (mounted && isLoading) {
        setState(() {
          showLoadingText = true;
        });
      }
    });

    var languageProvider = Provider.of<AppLanguageProvider>(
      context,
      listen: false,
    );

    try {
      final response = await ApiManager.getNewsBySourceId(
        sourceId: widget.source.id ?? "",
        language: languageProvider.appLanguage,
        page: currentPage,
        pageSize: 20, // Limit per page for pagination
      );

      // Handle API error response
      if (response?.status == 'error') {
        setState(() {
          errorMessage = response?.message ?? "Unknown server error";
          isLoading = false;
        });
        return;
      }

      // If articles are returned, add them to the list
      if (response != null && response.articles != null) {
        setState(() {
          articles.addAll(response.articles!);

          // If returned articles are less than the page size, no more data is available
          hasMore = response.articles!.length == 20;

          if (hasMore) currentPage++; // Increment page if more data exists
        });
      } else {
        setState(() => hasMore = false);
      }
    } catch (e) {
      // Catch any exception and store the message
      setState(() {
        errorMessage = "Something went wrong: $e";
      });
    }

    // Stop loading state
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // If there's an error and no articles loaded yet
    if (errorMessage != null && articles.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage!,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: fetchNews, // Retry fetching news
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

    // Show initial loading spinner when no articles yet
    if (articles.isEmpty && isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.greyColor),
      );
    }

    // Show "No Articles" message if list is empty and not loading
    if (articles.isEmpty && !isLoading) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noArticles,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    }

    // Show articles list
    return ListView.builder(
      controller: scrollController,
      itemCount: articles.length + 1, // Extra item for loading/no more message
      itemBuilder: (context, index) {
        if (index < articles.length) {
          var article = articles[index];
          return InkWell(
            onTap: () {
              // Show article details in a bottom sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => NewsDetailsBottomSheet(article: article),
              );
            },
            child: NewsItem(news: article),
          );
        } else {
          // Last item: loading indicator or "no more data" message
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: !hasMore
                  ? Text(
                      'No more news available',
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  : isLoading
                  ? const CircularProgressIndicator(color: AppColors.greyColor)
                  : const SizedBox.shrink(),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController
        .dispose(); // Dispose scroll controller to prevent memory leaks
    super.dispose();
  }
}
