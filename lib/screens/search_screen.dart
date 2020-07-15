import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class Prod {
  final String title;
  final String description;

  Prod(
    this.title,
    this.description,
  );
}

class SearchScreen extends StatelessWidget {
  Future<List<Prod>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(search.length, (int index) {
      return Prod(
        "Title : $search $index",
        "Description :$search $index",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Prod>(
            onSearch: search,
            onItemFound: (Prod prod, int index) {
              return ListTile(
                title: Text(prod.title),
                subtitle: Text(prod.description),
              );
            },
          ),
        ),
      ),
    );
  }
}
