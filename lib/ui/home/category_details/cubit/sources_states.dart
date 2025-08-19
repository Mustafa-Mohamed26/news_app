import 'package:news_app/model/source_response.dart';

abstract class SourcesStates {}

class SourceLoadingState extends SourcesStates {}

class SourceErrorState extends SourcesStates {
  String errorMessage;
  SourceErrorState({required this.errorMessage});
}

class SourceSuccessState extends SourcesStates {
  List<Source> sourcesList;
  SourceSuccessState({required this.sourcesList});
}
