/// Provides a base class for setting up how content is retrieved.
abstract class ContentRetriever<T> {
  const ContentRetriever();

  Future<List<T>> call({required int page});

  bool hasReachedEnd(List<T> content) => content.isEmpty;
}
