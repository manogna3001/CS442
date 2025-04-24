import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/alldecks.dart';
import '/models/deckmodel.dart';
import '../models/cardset.dart';
import '/models/cardmodel.dart';
import '/utils/dbHelper.dart';
import 'deckedit.dart';
import 'cardlist.dart';

class DeckList extends StatefulWidget {
  const DeckList({super.key});
  @override
  State<DeckList> createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  @override
  Widget build(BuildContext context) {
    final allDecks = Provider.of<DecksAll?>(context);

    if (allDecks == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Flashcard Decks",
              style: TextStyle(color: Color.fromARGB(255, 8, 7, 7))),
          backgroundColor: const Color.fromARGB(255, 223, 128, 40),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.download, color:  Color.fromARGB(255, 8, 7, 7)),
              onPressed: () async {
                await readJsonFile();
                List allDecksData = await reloadData();
                setState(() {
                  allDecks.clear();
                  for (var deck in allDecksData) {
                    allDecks.addInCollection(deck);
                  }
                });
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider<DecksAll>.value(
                    value: allDecks, child: const DeckEditPage(0));
              })).then((value) async {
                List allDecksData = await reloadData();
                setState(() {
                  allDecks.clear();
                  for (var deck in allDecksData) {
                    allDecks.addInCollection(deck);
                  }
                });
              });
            },
            child: const Icon(Icons.add)),
        body: 
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10),
                itemCount: allDecks.length,
                itemBuilder: (context, index) {
                  final deck = allDecks[index];
                  return Card(
                      color: Color.fromARGB(159, 226, 108, 12),
                      child: Container(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              InkWell(onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ChangeNotifierProvider<
                                          DecksAll>.value(
                                      value: allDecks,
                                      child: CardListPage(deck.deckId!));
                                })).then((value) async {
                                  List allDecksData = await reloadData();
                                  setState(() {
                                    allDecks.clear();
                                    for (var deck in allDecksData) {
                                      allDecks.addInCollection(deck);
                                    }
                                  });
                                });
                              }),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Flexible(
                                      child: Container(
                                    alignment: AlignmentDirectional.center,
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Column(children: [
                                      Center(child: Text(deck.title)),
                                      Center(
                                          child: Text(
                                              '(${deck.cardsCount} Cards)')),
                                    ]),
                                  )),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    var deckID=
                                        allDecks[index].deckId;
                                    //print('Deck ${allDecks[index].title} edited');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ChangeNotifierProvider<
                                              DecksAll>.value(
                                          value: allDecks,
                                          child: DeckEditPage(deckID!));
                                    })).then((value) async {
                                      List allDecksData= await reloadData();
                                      setState(() {
                                        allDecks.clear();
                                        for (var deck in allDecksData) {
                                          allDecks.addInCollection(deck);
                                        }
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          )));
                }));
    //],
    //));
  }

  Future<void> readJsonFile() async {
    // get raw data and make models , then save to db

    final data = await rootBundle.loadString('assets/flashcards.json');
    List decksCardsData = json.decode(data);
    await DBHelper()
        .jsonModelDB(decksCardsData, "decks", "cards");
  }

  }

  Future<List<DeckModel>> reloadData() async {
    // loading data to collections of decks and cards from db

    final deckData = await DBHelper().queryDecks();

    List<DeckModel> allDecks = List.empty(growable: true);

    for (var deck in deckData) {

      String whereClause = "deck_id= ${deck['deck_id'] as int}";

      final cardsData = await DBHelper().query("cards", where: whereClause);      
      CardSet cardSet = CardSet();

      if (cardsData.isNotEmpty) {
        for (var card in cardsData) {
          cardSet.addInCollection(FlashCardModel(
              question: card['question'],
              answer: card['answer'],
              deckId: card['deck_id'],
              cardId: card['card_id']));
        }
      }
      allDecks.add(DeckModel(
          deckId: deck['deck_id'] as int,
          title: deck['title'] as String,
          cardsCount: deck['cards_count'],
          cardSet: cardSet));
    }

    return allDecks;
  }