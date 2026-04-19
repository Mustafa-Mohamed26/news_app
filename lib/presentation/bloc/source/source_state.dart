import 'package:news_app/domain/entities/source_entity.dart';

abstract class SourceState {}

class SourceInitial extends SourceState {}
class SourceLoading extends SourceState {}
class SourceSuccess extends SourceState {
  final List<SourceEntity> sources;
  SourceSuccess(this.sources);
}
class SourceError extends SourceState {
  final String message;
  SourceError(this.message);
}
