import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/config/di/di.dart';
import 'package:news_app/core/l10n/app_localizations.dart';
import 'package:news_app/core/providers/app_language_provider.dart';
import 'package:news_app/presentation/bloc/news/news_view_model.dart';
import 'package:news_app/presentation/bloc/news/news_event.dart';
import 'package:news_app/presentation/bloc/news/news_state.dart';
import 'package:news_app/presentation/home/category_details/news/news_details_bottom_sheet.dart';
import 'package:news_app/presentation/home/category_details/news/news_item.dart';
import 'package:news_app/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class AllArticlesWidget extends StatefulWidget {
  final String searchQuery;
  const AllArticlesWidget({super.key, required this.searchQuery});

  @override
  State<AllArticlesWidget> createState() => _AllArticlesWidgetState();
}

class _AllArticlesWidgetState extends State<AllArticlesWidget> {
  late NewsViewModel _newsViewModel;

  @override
  void initState() {
    super.initState();
    _newsViewModel = getIt<NewsViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchNews();
  }

  @override
  void didUpdateWidget(covariant AllArticlesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _fetchNews();
    }
  }

  void _fetchNews() {
    var languageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
    _newsViewModel.add(LoadNewsEvent(
      sourceId: "", // Empty means no specific source → get all
      language: languageProvider.appLanguage,
      query: widget.searchQuery.isEmpty ? null : widget.searchQuery,
      page: 1, // Only get first page for search for simplicity
    ));
  }

  @override
  void dispose() {
    _newsViewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _newsViewModel,
      child: BlocBuilder<NewsViewModel, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading || state is NewsInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.greyColor));
          }

          if (state is NewsError) {
            return Center(
              child: Text(state.message, style: Theme.of(context).textTheme.labelMedium),
            );
          }

          if (state is NewsSuccess) {
            var articles = state.articles;
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
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
