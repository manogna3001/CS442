import 'package:flutter/material.dart';
import '../models/alldecks.dart';
import '/models/deckmodel.dart';
// import '../models/cardset.dart';
// import '/models/cardmodel.dart';
// import '/utils/dbHelper.dart';
import '/views/decklist.dart';
import 'cardedit.dart';
import 'quiz.dart';
import 'package:provider/provider.dart';

class CardListPage extends StatefulWidget {
  final int deckId;
  const CardListPage(this.deckId, {super.key});
  @override
  State<CardListPage> createState() => _FlashCardListState();
}

class _FlashCardListState extends State<CardListPage> {
  late DeckModel deck;
  late DecksAll allDecks;
  bool isSorted = false;
  @override
  void initState() {
    super.initState();
    allDecks = Provider.of<DecksAll>(context, listen: false);

    deck = DeckModel.from(allDecks.getDeckData(widget.deckId));
  }

  @override
  Widget build(BuildContext context) {
    final deckList = Provider.of<DecksAll?>(context);
    final flashCardList = deckList?.getFlashCardData(widget.deckId);
    const snackBar = SnackBar(
      content: Text('Add flashcards to play'),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(deck.title,
              style: TextStyle(color: Colors.black)),
          backgroundColor: const Color.fromARGB(255, 223, 128, 40),
          
          actions: <Widget>[
            IconButton(
              icon: isSorted
                  ? Icon(Icons.access_time, color: Colors.black)
                  : Icon(Icons.sort_by_alpha, color: Colors.black),
              
              onPressed: () async {
                List allDecksData = await reloadData();
                setState(() {
                  deckList?.clear();
                  for (var deck in allDecksData) {
                    if (isSorted) {
                      deckList?.addInCollection(deck);
                    } else {
                      deckList?.addInCollectionInSortOrder(deck);
                    }
                  }
                  if (isSorted) {
                    isSorted = false;
                  } else {
                    isSorted = true;
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow_sharp, color: Colors.black),
              onPressed: () {
                if (flashCardList != null) {
                  var deckId = widget.deckId;
                  var deckName = deck.title;
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ChangeNotifierProvider<DecksAll?>.value(
                        value: deckList, child: Quiz(deckId, deckName));
                  }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              var deckId = widget.deckId;

              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider<DecksAll?>.value(
                    value: deckList, child: CardEditPage(deckId, 0));
              })).then((value) async {
                isSorted = false;
                List allDecksData = await reloadData();
                setState(() {
                  deckList?.clear();
                  for (var deck in allDecksData) {
                    deckList?.addInCollection(deck);
                  }
                });
              });
            },
            child: const Icon(Icons.add)),
        body: flashCardList != null
            ? Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 185,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 10),
                          itemCount: flashCardList.length,
                          itemBuilder: (context, index) {
                            final flashCard = flashCardList[index];
                            return Card(
                                color: Color.fromARGB(255, 227, 177, 14),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        InkWell(onTap: () {
                                          var deckId = widget.deckId;
                                          var flashCardId = flashCard.cardId;
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) {
                                            return ChangeNotifierProvider<DecksAll?>.value(
                                                value: deckList,
                                                child: CardEditPage(deckId, flashCardId!));
                                          })).then((value) async {
                                            List allDecksData = await reloadData();
                                            setState(() {
                                              deckList?.clear();
                                              for (var deck in allDecksData) {
                                                deckList?.addInCollection(deck);
                                              }
                                            });
                                          });
                                        }),
                                        Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Flexible(
                                              child: Center(
                                                  child:
                                                      Text(flashCard.question,
                                                      textAlign: TextAlign.center)),
                                                      
                                            ),
                                          ],
                                        ),
                                      ],
                                    )));
                          }))
                ],
              )
            : Container());
  }
   
  }