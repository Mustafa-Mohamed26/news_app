import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/domain/use_cases/get_sources_use_case.dart';
import 'source_event.dart';
import 'source_state.dart';

@injectable
class SourceViewModel extends Bloc<SourceEvent, SourceState> {
  final GetSourcesUseCase getSourcesUseCase;

  SourceViewModel({required this.getSourcesUseCase}) : super(SourceInitial()) {
    on<LoadSourcesEvent>((event, emit) async {
      emit(SourceLoading());
      try {
        var sources = await getSourcesUseCase.execute(event.categoryId, event.language);
        emit(SourceSuccess(sources));
      } catch (e) {
        emit(SourceError(e.toString()));
      }
    });
  }
}
