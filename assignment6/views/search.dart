import 'package:flutter/material.dart';
import 'package:cs442_mp6/views/menu.dart';
import 'package:cs442_mp6/views/home.dart';
import 'package:cs442_mp6/views/search_results.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchKeyword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<String>(builder: (context) {
                  return const Home();
                }),
              );
            },
          ),
        ],
      ),
      drawer: const Menu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: "",
              decoration: const InputDecoration(
                hintText: 'Search Keyword',
                prefixIcon: Icon(Icons.search), // Search icon in the text field
              ),
              onChanged: (value) {
                searchKeyword = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
                onPressed: () {
                  search();
                },
                child: const Text(
                  'Search',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void search() {
    if (searchKeyword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a keyword or phrase")),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<String>(builder: (context) {
          return SearchResults(searchText: searchKeyword);
        }),
      );
    }
  }
}
