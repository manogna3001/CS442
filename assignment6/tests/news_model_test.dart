import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/models/news.dart';


void main() {
   group('News model tests', () {
    test('create a news object', () {
  
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
      expect(newsModel.source.id?.contains('test_SourceID'),
          true);
      expect(
          newsModel.source.name
              ?.contains("test_SourceName"),
          true);
      expect(
          newsModel.author?.contains('test_Author'), true);
      expect(newsModel.title?.contains("test_Title"), true);
      expect(
          newsModel.description
              ?.contains('test_Description'),
          true);
      expect(newsModel.url?.contains("test_Url"), true);
      expect(
          newsModel.urlToImage?.contains('test_urlToImage'),
          true);
      expect(
          newsModel.publishedAt
              ?.contains("test_PublishedAt"),
          true);
      expect(newsModel.content?.contains('test_Content'),
          true);
    });
  });
}