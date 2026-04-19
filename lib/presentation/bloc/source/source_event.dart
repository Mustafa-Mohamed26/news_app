abstract class SourceEvent {}

class LoadSourcesEvent extends SourceEvent {
  final String categoryId;
  final String language;

  LoadSourcesEvent({required this.categoryId, required this.language});
}
