import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '/utils/db_helper.dart';
import 'package:provider/provider.dart';
import 'decklist.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureProvider<DecksAll?>(
      create: (_) => _loadData(),
      initialData: null,
      child: const DeckList(),
    );
  }

  Future<DecksAll> _loadData() async {
    final decks = await DBHelper().queryDecks();
    DecksAll deckCollection = DecksAll();

    for (var deck in decks) {
      String where = "deck_id= ${deck['deck_id'] as int}";
      final cards = await DBHelper().query("cards", where: where);
      CardSet cardSet = CardSet();

      if (cards.isNotEmpty) {
        for (var card in cards) {
          cardSet.addInCollection(
            FlashCardModel(
              question: card['question'],
              answer: card['answer'],
              deckId: card['deck_id'],
              cardId: card['card_id'],
            ),
          );
        }
      }

      deckCollection.addInCollection(
        DeckModel(
          deckId: deck['deck_id'] as int,
          title: deck['title'] as String,
          cardsCount: deck['cards_count'],
          cardSet: cardSet,
        ),
      );
    }
    return deckCollection;
  }
}
class DeckEditPage extends StatefulWidget {
  final int deckId;

  const DeckEditPage(this.deckId, {super.key});

  @override
  State<DeckEditPage> createState() => _DeckEditPageState();
}

class _DeckEditPageState extends State<DeckEditPage> {
  late DeckModel deck;
  late DecksAll decks;

  @override
  void initState() {
    super.initState();
    decks = Provider.of<DecksAll>(context, listen: false);

    if (widget.deckId != 0) {
      deck = DeckModel.from(decks.getDeckData(widget.deckId));
    } else {
      deck = DeckModel(title: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    var deleteButton = widget.deckId == 0
        ? Container() 
        : TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              await decks.delete(widget.deckId);
              Navigator.of(context).pop();
            },
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Deck',
          style: TextStyle(color: Color.fromARGB(255, 8, 7, 7)),
        ),
        backgroundColor: Colors.deepPurple, 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextFormField(
                initialValue: deck.title,
                decoration: const InputDecoration(hintText: 'Deck Name'),
                onChanged: (value) => deck.title = value,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (widget.deckId == 0) {
                      decks.add(deck);
                    } else {
                      decks.update(widget.deckId, deck);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                deleteButton,
              ],
            ),
          ],
        ),
      ),
    );
  }
}