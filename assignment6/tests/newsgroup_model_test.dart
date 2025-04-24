import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/models/newsgroup.dart';
import 'package:cs442_mp6/models/news.dart';

void main() {
  group('News Group Model tests', () {
    test('Add a news in Group', () {
      var newsSourceModel = NewsSource(
          id: "test_SourceID",
          name: "test_SourceName");

      var newsModel = News(
          source: newsSourceModel,
          author: "test_Author",
          title: "test_Title",
          description: "test_Description",
          url: "test_Url",
          urlToImage: "test_urlToImage",
          publishedAt: "test_PublishedAt",
          content: "test_Content");
      NewsGroup collectionList = NewsGroup();
      collectionList.add(newsModel);
      expect(collectionList.length == 1, true);
    });

    test('A news item should be deleted from the Group', () {
      var newsSourceModel = NewsSource(
          id: "test_SourceID",
          name: "test_SourceName");
      var newsModel = News(
          source: newsSourceModel,
          author: "test_Author",
          title: "test_Title",
          description: "test_Description",
          url: "test_Url",
          urlToImage: "test_urlToImage",
          publishedAt: "test_PublishedAt",
          content: "test_Content",
          news_Id: 99);
      NewsGroup collectionList = NewsGroup();
      collectionList.add(newsModel);
      collectionList.delete(99);
      expect(collectionList.length == 0, true);
    });

    test('News list is not empty', () {
      var newsSource = NewsSource(
          id: "test_SourceID",
          name: "test_SourceName");
      var news = News(
          source: newsSource,
          author: "test_Author",
          title: "test_Title",
          description: "test_Description",
          url: "test_Url",
          urlToImage: "test_urlToImage",
          publishedAt: "test_PublishedAt",
          content: "test_Content");
      NewsGroup collectionList = NewsGroup();
      collectionList.add(news);
      expect(collectionList.isNotEmpty(), true);
    });
  });
}