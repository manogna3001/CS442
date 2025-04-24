import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:cs442_mp6/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:cs442_mp6/utils/db_helper.dart';

class NewsGroup {
  final List<News> _newsSet;

  NewsGroup() : _newsSet = List.empty(growable: true);

  int get length => _newsSet.length;
  News operator [](int index) => _newsSet[index];

  void add(News news) {
    _newsSet.add(news);
  }

  void delete(int? newsId) async {
    News news = _newsSet.firstWhere((element) => element.newsId == newsId);

    _newsSet.remove(news);

  }

  News? getNewsDetail(String? sourceId, String? sourceName) {
    News? news = _newsSet.firstWhereOrNull((element) =>
        element.source.id == sourceId && element.source.name == sourceName);

    return news;    
  }


  bool isNotEmpty() {
    return _newsSet.isNotEmpty;
  }
  

  Future<NewsGroup?> fetchData(String mainURL, String apiKey) async {

    String urlPath = '$mainURL?country=us';
    final response = await http.get(Uri.parse(urlPath), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    });
    final newsData = json.decode(response.body);

    if (newsData['status'] != 'ok') {
      throw Exception('Failed to load posts: ${newsData['message']}');
    }
    NewsGroup newsSet = NewsGroup();
    if (newsData['articles'] != null) {
      List<dynamic> articles = newsData['articles'];

      for (int i = 0; i < articles.length; i++) {
        if (articles[i]['title'] != "[Removed]") {
          final source = articles[i]['source'];
          NewsSource sourceModel =
              NewsSource(id: source['id'], name: source['name']);
          News news = News(
              source: sourceModel,
              author: articles[i]['author'],
              title: articles[i]['title'],
              description: articles[i]['description'],
              url: articles[i]['url'],
              urlToImage: articles[i]['urlToImage'],
              publishedAt: articles[i]['publishedAt'],
              content: articles[i]['content']);

          newsSet.add(news);
        }
      }      
    }
    return newsSet;
  }

  Future<NewsGroup> getFavoriteNews() async {

    String whereClause = "NewsCategory='favorite'";
    final favData =   await DBHelper().query("FavoriteOrSearchedNews", where: whereClause);

    NewsGroup favList = NewsGroup();

    for (int i = 0; i < favData.length; i++) {

      NewsSource sourceModel = NewsSource(id: favData[i]['SourceId'], name: favData[i]['SourceName']);
      
      News news = News(
          source: sourceModel,
          author: favData[i]['author'],
          title: favData[i]['title'],
          description: favData[i]['description'],
          url: "",
          urlToImage: "",
          publishedAt: "",
          content: "",
          newsId: favData[i]['FavoriteOrSearchedNewsId']);

      favList.add(news);
    }
    return favList;
  }
}