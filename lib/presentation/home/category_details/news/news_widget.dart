import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/config/di/di.dart';
import 'package:news_app/core/l10n/app_localizations.dart';
import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/core/providers/app_language_provider.dart';
import 'package:news_app/presentation/bloc/news/news_view_model.dart';
import 'package:news_app/presentation/bloc/news/news_event.dart';
import 'package:news_app/presentation/bloc/news/news_state.dart';
import 'package:news_app/presentation/home/category_details/news/news_details_bottom_sheet.dart';
import 'package:news_app/presentation/home/category_details/news/news_item.dart';
import 'package:news_app/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class NewsWidget extends StatefulWidget {
  final SourceEntity source;
  const NewsWidget({super.key, required this.source});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final ScrollController scrollController = ScrollController();
  late NewsViewModel _newsViewModel;

  @override
  void initState() {
    super.initState();
    _newsViewModel = getIt<NewsViewModel>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialNews();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (_newsViewModel.state is NewsSuccess) {
          final successState = _newsViewModel.state as NewsSuccess;
          if (successState.hasMore && !successState.isFetchingMore) {
            _loadMoreNews();
          }
        }
      }
    });
  }

  void _loadInitialNews() {
    var languageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
    _newsViewModel.add(LoadNewsEvent(
      sourceId: widget.source.id,
      language: languageProvider.appLanguage,
      page: 1,
    ));
  }

  void _loadMoreNews() {
    var languageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
    _newsViewModel.add(LoadNewsEvent(
      sourceId: widget.source.id,
      language: languageProvider.appLanguage,
      page: _newsViewModel.currentPage,
    ));
  }

  @override
  void didUpdateWidget(covariant NewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.id != widget.source.id) {
      _loadInitialNews();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    _newsViewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _newsViewModel,
      child: BlocBuilder<NewsViewModel, NewsState>(
        builder: (context, state) {
          if (state is NewsError && _newsViewModel.articlesList.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadInitialNews,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.greyColor),
                  child: Text('Try Again', style: Theme.of(context).textTheme.labelMedium),
                ),
              ],
            );
          }

          if (state is NewsLoading || state is NewsInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.greyColor));
          }

          if (state is NewsSuccess && state.articles.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noArticles,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            );
          }

          var articles = _newsViewModel.articlesList;
          bool isFetchingMore = state is NewsSuccess ? state.isFetchingMore : false;
          bool hasMore = state is NewsSuccess ? state.hasMore : false;

          return ListView.builder(
            controller: scrollController,
            itemCount: articles.length + 1,
            itemBuilder: (context, index) {
              if (index < articles.length) {
                var article = articles[index];
                return InkWell(
                  onTap: () {
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: !hasMore
                        ? Text('No more news available', style: Theme.of(context).textTheme.labelLarge)
                        : isFetchingMore
                        ? const CircularProgressIndicator(color: AppColors.greyColor)
                        : const SizedBox.shrink(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
