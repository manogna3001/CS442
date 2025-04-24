import 'package:flutter/material.dart';
import '/models/cardset.dart';
import '/models/cardmodel.dart';
import '/utils/dbHelper.dart';

class Quiz extends StatefulWidget {
  final int deckId;
  final String title;
  const Quiz(this.deckId, this.title, {super.key});
  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late Future<CardSet> cardSet;
  late List<bool> isPeeked;
  int cardsCount = 0;
  int viewedCount = 0;
  int index = 0;
  int peekedCount = 0;
  int seenCardsCount = 1;
  late List<bool> isCardSeen;
  bool isAnswerPeeked = false;
  @override
  void initState() {
    super.initState();
    cardSet = loadData();
  }

  Future<CardSet> loadData() async {
    String whereClause = "deck_id= ${widget.deckId}";
    final cardSetData = await DBHelper().query("cards", where: whereClause);
    CardSet cardSet = CardSet();
    if (cardSetData.isNotEmpty) {
      for (var card in cardSetData) {
        cardSet.addInCollection(FlashCardModel(
            question: card['question'],
            answer: card['answer'],
            deckId: card['deck_id'],
            cardId: card['card_id']));
      }
      cardSet.shuffle();
      cardsCount = cardSet.length;
      isPeeked = List.filled(cardSet.length, false);
      isCardSeen = List.filled(cardSet.length, false);
      isCardSeen[0] = true;
    }
    return cardSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.title} Quiz',
              style: TextStyle(color: Color.fromARGB(255, 8, 7, 7))),
          backgroundColor: const Color.fromARGB(255, 223, 128, 40),
        ),
        body: FutureBuilder<CardSet>(
            future: cardSet,
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final flashCard = snapshot.data![index];

                return Center(
                    child: Flex(direction: Axis.horizontal, children: [
                  Expanded(
                    child: Column(
                      children: [
                        isAnswerPeeked
                            ? Card(
                                color: Color.fromARGB(255, 138, 174, 238),
                                child: Container(
                                    height: 300,
                                    width: 300,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Flexible(
                                              child: Center(
                                                  child: Text(
                                                flashCard.answer,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )))
                            : Card(
                                color: Color.fromARGB(255, 13, 172, 235),
                                child: Container(
                                    height: 300,
                                    width: 300,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Flexible(
                                              child: Center(
                                                  child: Text(
                                                      flashCard.question,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {

                                  if (index == 0) {
                                   index = cardsCount;
                                  }
                                   setState(() {
                                      index--;
                                      isAnswerPeeked = false;
                                      print('index = $index, ${isCardSeen[index]}');
                                       if (isCardSeen[index] == false) {
                                        isCardSeen[index] = true;
                                        if (seenCardsCount != cardsCount)
                                            {seenCardsCount++;}
                                    }});
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                            isAnswerPeeked
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isAnswerPeeked = false;
                                      });
                                    },
                                    icon: const Icon(Icons.copy_all))
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isAnswerPeeked = true;
                                        if (isPeeked[index] == false) {
                                          isPeeked[index] = true;
                                          peekedCount++;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.copy_outlined)),
                            IconButton(
                                onPressed: () {
                                  print(index);
                                  if (index == cardsCount-1) {
                                    index = -1;

                                  }
                                    setState(() {
                                      index++;
                                      isAnswerPeeked = false;
                                      if (isCardSeen[index] == false) {
                                        isCardSeen[index] = true;
                                        if (seenCardsCount != cardsCount)
                                            {seenCardsCount++;}
                                      }
                                    });
                                  print(index);
                                },
                                icon: const Icon(Icons.arrow_forward_ios))
                          ],
                        ),
                        Text("Seen $seenCardsCount of $cardsCount"),
                        Text("Peeked $peekedCount out of $seenCardsCount")
                      ],
                    ),
                  )
                ]));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}