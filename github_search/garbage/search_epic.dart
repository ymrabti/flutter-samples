// import 'package:redux_epics/redux_epics.dart';
// import 'package:rxdart/rxdart.dart';

// import '../lib/github_client.dart';
// import '../lib/redux/search_actions.dart';
// import '../lib/redux/search_state.dart';

/* class SearchEpic implements EpicClass<SearchState> {
  final GithubClient api;

  SearchEpic(this.api);

  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<SearchState> store) {
    return actions
        .whereType<SearchAction>()
        .debounce((_) => TimerStream<void>(true, const Duration(milliseconds: 250)))
        .switchMap<dynamic>((action) => _search(action.term));
  }

  Stream<dynamic> _search(String term) async* {
    if (term.isEmpty) {
      yield SearchEmptyAction();
    } else {
      yield SearchLoadingAction();

      try {
        yield SearchResultAction(await api.search(term));
      } catch (e) {
        yield SearchErrorAction();
      }
    }
  }
}
 */