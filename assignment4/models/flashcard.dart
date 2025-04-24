import 'package:flutter/material.dart';
import '/utils/db_helper.dart';

/// Model for individual flashcards within a deck
class FlashCardModel {
  int? cardId;
  String question;
  String answer;
  final int deckId;

  FlashCardModel({
    this.cardId,
    required this.question,
    required this.answer,
    required this.deckId,
  });

  FlashCardModel.from(FlashCardModel other)
      : question = other.question,
        answer = other.answer,
        deckId = other.deckId,
        cardId = other.cardId;

  factory FlashCardModel.fromJson(Map<String, dynamic> cardData) {
    return FlashCardModel(
      question: cardData['question'] as String,
      answer: cardData['answer'] as String,
      deckId: 0,
    );
  }

  Future<void> saveFlashCards(FlashCardModel card, Future<int> deckId) async {
    await DBHelper().insert("cards", {
      'question': card.question,
      'answer': card.answer,
      'deck_id': deckId,
    });
  }

  Future<int> saveNewFlashCards(FlashCardModel card, int deckId) async {
    return await DBHelper().insert("cards", {
      'question': card.question,
      'answer': card.answer,
      'deck_id': deckId,
    });
  }

  Future<void> updateFlashCard(
      String question, String answer, int cardId, int deckId) async {
    await DBHelper().update(
      "cards",
      {
        'question': question,
        'answer': answer,
        'deck_id': deckId,
        'card_id': cardId,
      },
      "card_id",
    );
  }

  Future<void> deleteFlashCard(int cardId) async {
    await DBHelper().delete("cards", cardId, "card_id");
  }
}

/// Collection of flashcards within a deck
class CardSet extends ChangeNotifier {
  final List<FlashCardModel> cardSet;

  CardSet() : cardSet = List.empty(growable: true);

  int get length => cardSet.length;

  FlashCardModel operator [](int index) => cardSet[index];

  void addInCollection(FlashCardModel card) {
    cardSet.add(card);
    notifyListeners();
  }

  FlashCardModel find(int cardID) {
    return cardSet.firstWhere((element) => element.cardId == cardID);
  }

  void removeWhere(int cardID) {
    cardSet.removeWhere((element) => element.cardId == cardID);
  }

  void clear() {
    cardSet.clear();
    notifyListeners();
  }

  List<FlashCardModel> getList() => cardSet;

  List<FlashCardModel> sortOrder() {
    cardSet.sort((a, b) => a.question.compareTo(b.question));
    return cardSet;
  }

  List<FlashCardModel> shuffle() {
    cardSet.shuffle();
    return cardSet;
  }
}

/// Model for individual decks, each containing a set of flashcards
class DeckModel with ChangeNotifier {
  int? deckId;
  String title;
  int? cardsCount;
  CardSet? cardSet;

  DeckModel({
    this.deckId,
    required this.title,
    this.cardsCount,
    this.cardSet,
  });

  factory DeckModel.fromJson(Map<String, dynamic> deckData) {
    String title = deckData['title'];
    List cardSetData = deckData['flashcards'];
    CardSet cardSet = CardSet();

    for (var cardData in cardSetData) {
      FlashCardModel card = FlashCardModel.fromJson(cardData);
      cardSet.addInCollection(card);
    }

    return DeckModel(
      deckId: 1,
      title: title,
      cardsCount: cardSet.length,
      cardSet: cardSet,
    );
  }

  Future<int> saveDeck(String titleName) async {
    int deckID = await DBHelper().insert("decks", {'title': title});
    return deckID;
  }

  DeckModel.from(DeckModel other)
      : deckId = other.deckId,
        title = other.title;

  Future<void> updateDeck(String titleName, int deckId) async {
    await DBHelper().update(
        "decks", {'title': title, 'deck_id': deckId}, "deck_id");
  }

  Future<void> deleteDeck(int deckId) async {
    await DBHelper().deleteDeck("decks", "cards", deckId, "deck_id");
  }
}

/// Collection of all decks, managing deck-level operations
class DecksAll with ChangeNotifier {
  final List<DeckModel> allDecks;

  DecksAll() : allDecks = List.empty(growable: true);

  int get length => allDecks.length;

  DeckModel operator [](int index) => allDecks[index];

  Future<void> update(int deckId, DeckModel deck) async {
    DeckModel oldDeck =
        allDecks.firstWhere((element) => element.deckId == deck.deckId);
    oldDeck.title = deck.title;
    deck.updateDeck(deck.title, deckId);
    notifyListeners();
  }

  void add(DeckModel deck) {
    allDecks.add(deck);
    deck.saveDeck(deck.title);
    notifyListeners();
  }

  void addInCollection(DeckModel deck) {
    allDecks.add(deck);
    notifyListeners();
  }

  void addInCollectionInSortOrder(DeckModel deck) {
    CardSet? cardSet = deck.cardSet;
    if (cardSet != null && cardSet.length > 0) {
      List<FlashCardModel> cardSetSortedList = cardSet.sortOrder();
      CardSet cardSetSorted = CardSet();
      for (var card in cardSetSortedList) {
        cardSetSorted.addInCollection(card);
      }
      deck.cardSet = cardSetSorted;
    }
    allDecks.add(deck);
    notifyListeners();
  }

  void clear() {
    allDecks.clear();
    notifyListeners();
  }

  Future<void> delete(int deckId) async {
    DeckModel deck =
        allDecks.firstWhere((element) => element.deckId == deckId);
    deck.deleteDeck(deckId);
    notifyListeners();
  }

  DeckModel getDeckData(int deckID) {
    return allDecks.firstWhere((element) => element.deckId == deckID);
  }

  CardSet? getFlashCardData(int deckID) {
    DeckModel deck =
        allDecks.firstWhere((element) => element.deckId == deckID);
    return deck.cardsCount == 0 ? null : deck.cardSet;
  }

  FlashCardModel? getCard(int deckId, int cardID) {
    DeckModel deck =
        allDecks.firstWhere((element) => element.deckId == deckId);
    return deck.cardSet?.find(cardID);
  }

  void addFlashCard(FlashCardModel card) {
    card.saveFlashCards(card, card.deckId as Future<int>);
    notifyListeners();
  }

  Future<void> addNewFlashCard(FlashCardModel card, int deckId) async {
    await card.saveNewFlashCards(card, deckId);
    notifyListeners();
  }

  Future<void> updateFlashCard(
      int flashCardId, int deckId, FlashCardModel? card) async {
    card?.updateFlashCard(card.question, card.answer, flashCardId, deckId);
    notifyListeners();
  }

  Future<void> deleteCard(int deckId, int flashCardId) async {
    DeckModel deck =
        allDecks.firstWhere((element) => element.deckId == deckId);
    FlashCardModel card = deck.cardSet!.find(flashCardId);
    card.deleteFlashCard(flashCardId);
    deck.cardSet?.removeWhere(flashCardId);
    notifyListeners();
  }
}
