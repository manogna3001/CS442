import 'package:cs442_mp6/utils/db_helper.dart';

class News {
  int? newsId;
  NewsSource source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  News(
      {required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content,
      this.newsId});

  Future<int> dbInsert(String newsCategoryName) async {
    int id = await DBHelper().insert('FavoriteOrSearchedNews', {
      'SourceId': source.id,
      'SourceName': source.name,
      'Author': author,
      'Title': title,
      'Description': description,
      'NewsCategory': newsCategoryName
    });
    return id;
  }

  Future<void> dbDelete() async {
    await DBHelper().delete('FavoriteOrSearchedNews', newsId ?? 0, "FavoriteOrSearchedNewsId");
  }
}

class NewsSource {
  String? id;
  String? name;

  NewsSource({required this.id, required this.name});
}