import 'package:flutter/widgets.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/providers/app_language_provider.dart';
import 'package:provider/provider.dart';

class CategoryViewModel extends ChangeNotifier {
  // hold data - handle logic
  List<Source> sourcesList = [];
   String? errorMessage;

  void getSources(String categoryID) async {
    // reinitialize
    sourcesList = [];
    errorMessage = null;
    try {
      var response = await ApiManager.getSources(categoryID: categoryID);
      if (response?.status == "error") {
        errorMessage = response!.message!;
      } else {
        sourcesList = response!.sources!;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}
