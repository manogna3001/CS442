import 'package:flutter/material.dart';
import 'package:cs442_mp6/models/newsgroup.dart';
import 'package:cs442_mp6/models/news.dart';
import 'package:cs442_mp6/views/menu.dart';
import 'package:cs442_mp6/utils/db_helper.dart';


class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});
  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  late Future<NewsGroup> searchedList;

  @override
  void initState() {
    super.initState();
    searchedList = _searchedNews();
  }

  Future<NewsGroup> _searchedNews() async {
    String whereClause = "NewsCategory='searched'";
    final historyData = await DBHelper().query("FavoriteOrSearchedNews", where: whereClause);

    NewsGroup history = NewsGroup();

    for (int i = 0; i < historyData.length; i++) {
      NewsSource sourceModel = NewsSource(id: historyData[i]['SourceId'], name: historyData[i]['SourceName']);

      News newsDetails = News(
          source: sourceModel,
          author: historyData[i]['Author'],
          title: historyData[i]['Title'],
          description: historyData[i]['Description'],
          url: "",
          urlToImage: "",
          publishedAt: "",
          content: "",
          newsId: historyData[i]['FavoriteOrSearchedNewsId']);

      history.add(newsDetails);
    }
    return history;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search History",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: const Menu(),
      body: FutureBuilder<NewsGroup>(
        future: searchedList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty()) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final article = snapshot.data![index];
                  int? id = article.newsId;
                  return ListTile(
                      title: Text(
                        article.title ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            
                            deleteSearched(id);
                          },
                          icon: const Icon(Icons.delete_rounded)),
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
                child: Text("No articles in history"),
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

  Future<void> deleteSearched(int? id) async {
    if (id != null) {
      await DBHelper().delete(
          'FavoriteOrSearchedNews', id ?? 0, "FavoriteOrSearchedNewsId");
      setState(() {
        searchedList = _searchedNews();
      });
    }
  }
}