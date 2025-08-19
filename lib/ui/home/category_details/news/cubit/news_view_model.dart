import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/ui/home/category_details/news/cubit/news_states.dart';

class NewsViewModel extends Cubit<NewsStates> {
  NewsViewModel() : super(NewsLoadingState());

  // hold data - handle logic

  void getNewsBySourceId(String sourceId, String language) async {
    try {
      emit(NewsLoadingState());
      var response = await ApiManager.getNewsBySourceId(
        sourceId: sourceId,
        language: language,
      );
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
