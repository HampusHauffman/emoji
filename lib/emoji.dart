import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_count/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Emoji {
  String emoji;
  List<DateTime> count = [];

  Emoji({required this.emoji, required this.count});

  factory Emoji.fromJson(Map<String, dynamic> data) => Emoji(
      emoji: data["emoji"],
      count: data["count"] != null
          ? (data["count"] as List<dynamic>)
              .map((k) => DateTime.parse(k))
              .toList()
          : []);

  Map<String, dynamic> toMap() {
    return {
      "emoji": emoji,
      "count": count.map((e) => e.toIso8601String()).toList()
    };
  }

  @override
  String toString() {
    return "$emoji: ${count.toString()}";
  }
}

class EmojiProvider extends ChangeNotifier {
  List<Emoji> emojis;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late User user;

  int get largestCount => emojis.length > 1
      ? emojis
          .reduce((value, element) =>
              value.count.length > element.count.length ? value : element)
          .count
          .length
      : 1;

  DocumentReference<Map<String, dynamic>> get docRef =>
      db.collection("users").doc(user.uid);

  Map<String, dynamic> toMap() {
    return {
      "emojis": emojis.map((e) => e.toMap()),
    };
  }

  EmojiProvider({required this.emojis}) {
    setup();
  }

  setup() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        signInWithGoogle();
      } else {
        debugPrint("user is signed in: ${user.uid}");
        this.user = user;
        load();
      }
    });
  }

  handleSnap(DocumentSnapshot<Map<String, dynamic>> event) {
    if (event.data()?["emojis"] != null) {
      var k = (event.data()?["emojis"] as List<dynamic>)
          .map((e) => Emoji.fromJson(e))
          .toList();
      debugPrint(k.toString());
      emojis = k;
      notifyListeners();
    }
  }

  load() {
    docRef.set({}, SetOptions(merge: true));
    docRef.snapshots().listen(
          (event) => {handleSnap(event)},
        );
  }

  clickEmoji(int index) {
    emojis[index].count.add(DateTime.now());
    docRef.update(toMap());
  }

  addEmoji(String e) {
    emojis.add(Emoji(emoji: e, count: []));
    docRef.update(toMap());
  }

  void removeEmoji(int index) {
    debugPrint(index.toString());
    emojis.removeAt(index);
    docRef.update(toMap());
  }
}
