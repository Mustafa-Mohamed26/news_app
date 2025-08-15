import 'package:flutter/widgets.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/news_response.dart';

class NewsViewModel extends ChangeNotifier {
  // hold data - handle logic

  List<Articles>? newsList;
  String? errorMessage;

  void getNewsBySourceId(String sourceId) async {
    try {
      var response = await ApiManager.getNewsBySourceId(sourceId: sourceId);
      if (response?.status == "error") {
        errorMessage = response!.message!;
      } else {
        newsList = response!.articles!;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}
