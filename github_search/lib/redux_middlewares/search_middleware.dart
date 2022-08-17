import 'dart:async';

import 'package:async/async.dart';
import 'package:redux/redux.dart';

import '../github_client.dart';
import '../redux/search_actions.dart';
import '../redux/search_state.dart';

class SearchMiddleware implements MiddlewareClass<SearchState> {
  final GithubClient api;

  Timer? _timer;
  CancelableOperation<Store<SearchState>>? _operation;

  SearchMiddleware(this.api);

  @override
  void call(Store<SearchState> store, dynamic action, NextDispatcher next) {
    if (action is SearchAction) {
      _timer?.cancel();
      _operation?.cancel();

      _timer = Timer(const Duration(milliseconds: 250), () {
        if (action.term.isEmpty) {
          store.dispatch(SearchEmptyAction());
        } else {
          store.dispatch(SearchLoadingAction());

          _operation = CancelableOperation.fromFuture(api
              .search(action.term)
              .then((result) => store..dispatch(SearchResultAction(result)))
              .catchError((Object e, StackTrace s) => store..dispatch(SearchErrorAction())));
        }
      });
    }

    next(action);
  }
}
