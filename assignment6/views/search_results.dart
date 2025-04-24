import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cs442_mp6/models/newsgroup.dart';
import 'package:cs442_mp6/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:cs442_mp6/views/menu.dart';
import 'package:cs442_mp6/views/search.dart';

class SearchResults extends StatefulWidget {
 
  final String searchText;
  final url = "https://newsapi.org/v2/top-headlines";
  final apiKey = "ae99aa5d25194b29b1fbd256ddc8bf1d";

  const SearchResults(
      {required this.searchText,
      super.key});
  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late Future<NewsGroup> newsDetailsSearchedList;
  @override
  void initState() {
    
    super.initState();
    newsDetailsSearchedList = _loadNews();
  }

  Future<NewsGroup> _loadNews() async {
    String query = "";
    

    if (widget.searchText != "") {
      if (query == "") {
        query = "?q=${widget.searchText}";
      } else {
        query = "&q=${widget.searchText}";
      }
    }

    String urlPath = '${widget.url}$query';
    print(urlPath);
    final response = await http.get(Uri.parse(urlPath), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.apiKey}'
    });
    final newsJson = json.decode(response.body);

    if (newsJson['status'] != 'ok') {
      throw Exception('Failed to load posts: ${newsJson['message']}');
    }
    NewsGroup news = NewsGroup();
    if (newsJson['articles'] != null) {
      List<dynamic> articles = newsJson['articles'];

      for (int i = 0; i < articles.length; i++) {
        if (articles[i]['title'] != "[Removed]") {
          final source = articles[i]['source'];
          NewsSource sourceModel =
              NewsSource(id: source['id'], name: source['name']);
          News newsDetails = News(
              source: sourceModel,
              author: articles[i]['author'],
              title: articles[i]['title'],
              description: articles[i]['description'],
              url: articles[i]['url'],
              urlToImage: articles[i]['urlToImage'],
              publishedAt: articles[i]['publishedAt'],
              content: articles[i]['content']);
          addSearched(newsDetails);
          news.add(newsDetails);
        }
      }
    }
    return news;
  }

  Future<void> addSearched(News newsDetails) async {
    await newsDetails.dbInsert("searched");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
            
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<String>(builder: (context) {return const Search();}),);
              },
            )
          ],
      ),
      drawer: const Menu(),
      body: FutureBuilder<NewsGroup>(
        future: newsDetailsSearchedList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 1) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final article = snapshot.data![index];

                  return ListTile(
                      title: Text(
                        article.title ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(article.description ?? ''),
                          const SizedBox(height: 8),
                          Text(
                            article.author ?? 'Unknown',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Divider(),
                        ],
                      ));
                },
              );
            } else {
              return const Center(
                child: Text("No articles found.Try rephrasing the search"),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}