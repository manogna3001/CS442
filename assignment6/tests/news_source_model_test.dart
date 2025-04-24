import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/models/news.dart';

void main() {
  group('Test - News Source Model', () {
    test('create a news Source', () {
      var newsSourceModel =
          NewsSource(id: "test_SourceID", name: "test_SourceName");
      expect(newsSourceModel.id?.contains('test_SourceID'), true);
      expect(newsSourceModel.name?.contains("test_SourceName"), true);
    });
  });
}