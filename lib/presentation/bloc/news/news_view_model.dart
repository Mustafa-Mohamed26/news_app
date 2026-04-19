import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/domain/entities/article_entity.dart';
import 'package:news_app/domain/use_cases/get_news_use_case.dart';
import 'news_event.dart';
import 'news_state.dart';

/// ViewModel (BLoC) responsible for managing the state of news articles.
/// 
/// It captures [LoadNewsEvent]s from the UI and coordinates with the 
/// [GetNewsUseCase] to retrieve data from the repository layers.
@injectable
class NewsViewModel extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;
  
  // Track pagination and list state internally for easy UI rendering
  List<ArticleEntity> articlesList = [];
  int currentPage = 1;
  static const int pageSize = 20;
  bool hasMore = true;

  NewsViewModel({required this.getNewsUseCase}) : super(NewsInitial()) {
    on<LoadNewsEvent>((event, emit) async {
      final isInitialLoad = event.page == 1;

      if (isInitialLoad) {
        currentPage = 1;
        hasMore = true;
        
        // 1. Try to fetch from Cache INSTANTLY for page 1
        try {
          final cachedArticles = await getNewsUseCase.repository.getNewsFromCache(
            sourceId: event.sourceId,
            language: event.language,
            page: 1,
            pageSize: event.pageSize,
            query: event.query,
          );
          if (cachedArticles != null && cachedArticles.isNotEmpty) {
            articlesList = List.from(cachedArticles);
            emit(NewsSuccess(articlesList, hasMore));
          } else {
            emit(NewsLoading());
          }
        } catch (e) {
          emit(NewsLoading());
        }
      } else {
        emit(NewsSuccess(articlesList, hasMore, isFetchingMore: true));
      }

      // 2. Fetch from Remote
      try {
        var articles = await getNewsUseCase.execute(
          sourceId: event.sourceId,
          language: event.language,
          page: event.page,
          pageSize: event.pageSize,
          query: event.query,
        );
        
        if (isInitialLoad) {
          articlesList = articles; // Overwrite cache with fresh data
        } else {
          articlesList.addAll(articles);
        }
        
        hasMore = articles.length == event.pageSize;
        currentPage++;
        emit(NewsSuccess(articlesList, hasMore));
      } catch (e) {
        if (isInitialLoad && articlesList.isEmpty) {
          emit(NewsError(e.toString()));
        } else {
          // If we had cached data or were fetching more, just stop the loading state
          emit(NewsSuccess(articlesList, hasMore, isFetchingMore: false));
        }
      }
    });
  }
}
