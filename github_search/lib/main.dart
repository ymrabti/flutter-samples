import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github_search/redux_middlewares/search_middleware.dart';
import 'package:redux/redux.dart';

import 'github_client.dart';
import 'redux/search_reducer.dart';
import 'views/search_screen.dart';
import 'redux/search_state.dart';

// https://www.tiktok.com/@ahl_meo/video/7057348071344065793
void main() {
  final store = Store<SearchState>(
    searchReducer,
    initialState: SearchInitial(),
    middleware: [
      SearchMiddleware(GithubClient()),
      //   EpicMiddleware<SearchState>(SearchEpic(GithubClient())),
    ],
  );

  runApp(RxDartGithubSearchApp(
    store: store,
  ));
}

class RxDartGithubSearchApp extends StatelessWidget {
  final Store<SearchState> store;

  const RxDartGithubSearchApp({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<SearchState>(
      store: store,
      child: MaterialApp(
        title: 'RxDart Github Search',
        // debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.red,
        ),
        home: const SearchScreen(),
      ),
    );
  }
}
