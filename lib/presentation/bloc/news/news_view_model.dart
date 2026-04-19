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
      if (event.page == 1) {
        currentPage = 1;
        articlesList.clear();
        hasMore = true;
        emit(NewsLoading());
      } else {
        emit(NewsSuccess(articlesList, hasMore, isFetchingMore: true));
      }

      try {
        var articles = await getNewsUseCase.execute(
          sourceId: event.sourceId,
          language: event.language,
          page: event.page,
          pageSize: event.pageSize,
          query: event.query,
        );
        hasMore = articles.length == event.pageSize;
        articlesList.addAll(articles);
        currentPage++;
        emit(NewsSuccess(articlesList, hasMore));
      } catch (e) {
        if (event.page == 1) {
          emit(NewsError(e.toString()));
        } else {
          emit(NewsSuccess(articlesList, hasMore, isFetchingMore: false));
        }
      }
    });
  }
}
