/// Provides a base class for setting up how content is retrieved.
abstract class ContentRetriever {
  const ContentRetriever();

  Future<List<Object>> call({required int page});
}
