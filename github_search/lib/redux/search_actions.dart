import '../search_result.dart';

/// Actions
class SearchAction {
  final String term;
  SearchAction(this.term);
}

class SearchResultAction {
  final SearchResult result;
  SearchResultAction(this.result);
}

class SearchEmptyAction {}

class SearchLoadingAction {}

class SearchErrorAction {}
