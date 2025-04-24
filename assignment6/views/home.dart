import 'package:flutter/material.dart';
import 'package:cs442_mp6/models/newsgroup.dart';
import 'package:cs442_mp6/models/news.dart';
import 'package:cs442_mp6/views/menu.dart';
import 'package:cs442_mp6/views/search.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final url = "https://newsapi.org/v2/top-headlines";
  final apiKey = "ae99aa5d25194b29b1fbd256ddc8bf1d";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<NewsGroup?> newsSet;
  NewsGroup favSet = NewsGroup();

  @override
  void initState() {
    super.initState();
    _FavoriteNews();
  }

  Future<void> _loadData() async {
    newsSet = NewsGroup().fetchData(widget.url, widget.apiKey);
  }

  Future<void> _FavoriteNews() async {
    NewsGroup favList = await NewsGroup().getFavoriteNews();
    setState(() {
      favSet = favList;
    });
  }

  void reloadData() {
    setState(() {
      _loadData();
      _FavoriteNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsList = Provider.of<NewsGroup?>(context);

    if (newsList == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "News Today",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              reloadData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<String>(builder: (context) {
                  return const Search();
                }),
              );
            },
          ),
        ],
      ),
      drawer: const Menu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final article = newsList[index];

            // Check if this news is in favorites before display
            bool isFavorite = false;
            News? news = favSet.getNewsDetail(article.source.id, article.source.name);
            if (news != null) {
              isFavorite = true;
            }

            // Format the published time
            String publicationTime = article.publishedAt != null
                ? _formatPublishedDate(article.publishedAt!)
                : "Unknown";

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            article.title ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            key: Key('text_$index'),
                          ),
                        ),
                        IconButton(
                          key: Key('icon_$index'),
                          onPressed: () {
                            if (isFavorite) {
                              // Remove from favorites
                              removeFavorite(news!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Removed from Favorites")),
                              );
                              setState(() {
                                _FavoriteNews();
                              });
                            } else {
                              // Add to favorites
                              addFavorite(article);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Added to Favorites")),
                              );
                              setState(() {
                                _FavoriteNews();
                              });
                            }
                          },
                          icon: isFavorite
                              ? const Icon(Icons.star, color: Colors.amber)
                              : const Icon(Icons.star_border_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Description Section
                    Text(
                      article.description ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // Publication Time Section
                    Text(
                      'Published: $publicationTime',
                      style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                    const Divider(color: Colors.black12, thickness: 1),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatPublishedDate(String publishedAt) {
    DateTime dateTime = DateTime.parse(publishedAt);
    return "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }

  Future<void> addFavorite(News news) async {
    await news.dbInsert("favorite");

    setState(() {
      _FavoriteNews();
    });
  }

  Future<void> removeFavorite(News news) async {
    news.dbDelete();
    favSet.delete(news.newsId);
    setState(() {
      _FavoriteNews();
    });
  }
}
