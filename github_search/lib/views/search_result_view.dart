import 'package:flutter/material.dart';

import 'package:github_search/search_result.dart';

class SearchPopulatedView extends StatelessWidget {
  final SearchResult result;

  const SearchPopulatedView(this.result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: result.items.length,
      itemBuilder: (context, index) {
        final item = result.items[index];
        return _SearchItem(item: item);
      },
    );
  }
}

class _SearchItem extends StatelessWidget {
  const _SearchItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SearchResultItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: GestureDetector(
                  key: Key(item.avatarUrl),
                  onTap: () => Navigator.pop(context),
                  child: SizedBox.expand(
                    child: Hero(
                      tag: item.fullName,
                      child: Image.network(
                        item.avatarUrl,
                        width: MediaQuery.of(context).size.width * .5,
                        height: 300.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      child: Container(
        alignment: FractionalOffset.center,
        margin: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Hero(
                tag: item.fullName,
                child: ClipOval(
                  child: Image.network(
                    item.avatarUrl,
                    width: 56.0,
                    height: 56.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      top: 6.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      item.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    item.url,
                    style: const TextStyle(
                      fontFamily: 'Hind',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
