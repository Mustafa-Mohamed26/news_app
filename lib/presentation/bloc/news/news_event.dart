abstract class NewsEvent {}

class LoadNewsEvent extends NewsEvent {
  final String sourceId;
  final String language;
  final int page;
  final int pageSize;
  final String? query;

  LoadNewsEvent({
    required this.sourceId,
    required this.language,
    this.page = 1,
    this.pageSize = 20,
    this.query,
  });
}
