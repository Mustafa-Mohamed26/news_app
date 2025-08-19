import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/ui/home/category_details/cubit/sources_states.dart';

class SourcesViewModel extends Cubit<SourcesStates> {
  SourcesViewModel() : super(SourceLoadingState());

  // hold data - handle logic
  // List<Source>? sourceList;
  // String? errorMessage;

  void getSources(String categoryID, String language) async {
    try {
      // loading
      emit(SourceLoadingState());
      var response = await ApiManager.getSources(categoryID, language);
      if (response?.status == "error") {
        // error
        emit(SourceErrorState(errorMessage: response!.message!));
        return;
      }
      if (response?.status == "ok") {
        // success
        emit(SourceSuccessState(sourcesList: response!.sources!));
        return;
      }
    } catch (e) {
      emit(SourceErrorState(errorMessage: e.toString()));
    }
  }
}
