import 'package:flutter/material.dart';

import '../main.dart';

class LocalSearchAppBarPage extends StatelessWidget {
  const LocalSearchAppBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(MyApp.title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                showSearch(context: context, delegate: CitySearch());

                // final results = await
                //     showSearch(context: context, delegate: CitySearch());

                // print('Result: $results');
              },
            )
          ],
          backgroundColor: Colors.purple,
        ),
        body: Container(
          color: Colors.black,
          child: const Center(
            child: Text(
              'Local Weather Search',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 64,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}

class CitySearch extends SearchDelegate<String> {
  final cities = [
    'Berlin',
    'Paris',
    'Munich',
    'Hamburg',
    'London',
  ];

  final recentCities = [
    'Berlin',
    'Munich',
    'London',
  ];

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, 'Closing');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, 'Closed'),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_city, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? recentCities
        : cities.where((city) {
            final cityLower = city.toLowerCase();
            final queryLower = query.toLowerCase();

            return cityLower.startsWith(queryLower);
          }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;

              // 1. Show Results
              showResults(context);

              // 2. Close Search & Return Result
              // close(context, suggestion);

              // 3. Navigate to Result Page
              //  Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => ResultPage(suggestion),
              //   ),
              // );
            },
            leading: const Icon(Icons.location_city),
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
