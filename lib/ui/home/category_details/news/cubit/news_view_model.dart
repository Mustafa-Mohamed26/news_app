import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/data/repository/news/data_sources/remote/impl/news_remote_data_source_impl.dart';
import 'package:news_app/data/repository/news/data_sources/remote/news_remote_data_source.dart';
import 'package:news_app/data/repository/news/repository/impl/news_repository_impl.dart';
import 'package:news_app/data/repository/news/repository/news_repository.dart';
import 'package:news_app/ui/home/category_details/news/cubit/news_states.dart';

class NewsViewModel extends Cubit<NewsStates> {
   NewsRepository newsRepository;
  
  NewsViewModel({required this.newsRepository}) : super(NewsLoadingState()) ;

  // hold data - handle logic

  void getNewsBySourceId(String sourceId, String language) async {
    try {
      emit(NewsLoadingState());
      var response = await newsRepository.getNewsBySourceId(sourceId, language);
      if (response?.status == "error") {
        emit(NewsErrorState(errorMessage: response!.message!));
        return;
      }
      if (response?.status == "ok") {
        emit(NewsSuccessState(newsList: response!.articles!));
        return;
      }
    } catch (e) {
      emit(NewsErrorState(errorMessage: e.toString()));
    }
  }
}
