import 'package:flutter/material.dart';
import 'package:cs442_mp6/models/newsgroup.dart';
import 'package:cs442_mp6/views/home.dart';
import 'package:provider/provider.dart';

class NewsApp extends StatefulWidget {
  final url = "https://newsapi.org/v2/top-headlines";
  final apiKey = "ae99aa5d25194b29b1fbd256ddc8bf1d";

  const NewsApp({super.key});
  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  
  Future<NewsGroup?> _loadData() async {
    return await NewsGroup().fetchData(widget.url, widget.apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<NewsGroup?>(
      create: (_) => _loadData(),
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}