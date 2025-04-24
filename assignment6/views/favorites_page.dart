import 'package:flutter/material.dart';
import 'package:cs442_mp6/models/NewsGroup.dart';
import 'package:cs442_mp6/models/news.dart';
import 'package:cs442_mp6/utils/db_helper.dart';
import 'package:cs442_mp6/views/menu.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<NewsGroup> favoriteList;

  @override
  void initState() {
    super.initState();
    favoriteList = getFavoriteNews();
  }

    Future<NewsGroup> getFavoriteNews() async {

    String whereClause = "NewsCategory='favorite'";
    final favData =  await DBHelper().query("FavoriteOrSearchedNews", where: whereClause);

    NewsGroup favList = NewsGroup();
    
    for (int i = 0; i < favData.length; i++) {
    
      NewsSource sourceModel = NewsSource(id: favData[i]['SourceId'], name: favData[i]['SourceName']);
      
      News news = News(
          source: sourceModel,
          author: favData[i]['Author'],
          title: favData[i]['Title'],
          description: favData[i]['Description'],
          url: "",
          urlToImage: "",
          publishedAt: "",
          content: "",
          newsId: favData[i]['FavoriteOrSearchedNewsId']);

      favList.add(news);
    }
    return favList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite News", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: const Menu(),
      body: FutureBuilder<NewsGroup>(
        future: favoriteList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final article = snapshot.data![index];

                  return ListTile(
                      title: Text(
                        article.title ?? 'No title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                           removeFavorite(article);
                          },
                          icon: const Icon(Icons.star)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(article.description ?? 'No description'),
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
                child: Text("No articles in Favorites"),
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

  Future<void> removeFavorite(News newsDetails) async {
    await newsDetails.dbDelete();

    setState(() {
      favoriteList = getFavoriteNews();
    });
  }
}