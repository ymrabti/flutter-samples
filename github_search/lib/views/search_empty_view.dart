import 'package:flutter/material.dart';

class SearchEmptyView extends StatelessWidget {
  const SearchEmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.warning,
            color: Color(0xFFFF0000),
            size: 80.0,
          ),
          Container(
            padding: const EdgeInsets.only(top: 16.0),
            child: const Text(
              'No results',
              style: TextStyle(color: Color(0xFFFF0000)),
            ),
          )
        ],
      ),
    );
  }
}
