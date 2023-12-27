import 'package:equatable/equatable.dart';

abstract class ContentRetrieverDelegate<Data> extends Equatable {
  const ContentRetrieverDelegate();

  Future<List<Data>> retrieveContent({required int page});

  /// Function used to check if there are no more pages to be loaded
  bool hasReachedEnd(
      {required List<Data> oldContent, required List<Data> newContent,}) {
    final combinedContent = {...oldContent, ...newContent}.toList();

    return combinedContent.length == oldContent.length;
  }

  @override
  List<Object?> get props => [];
}
