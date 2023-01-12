import 'package:bordered_text/bordered_text.dart';
import 'package:collection/collection.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Emoji {
  String e;
  List<DateTime> c;

  Emoji({required this.e, required this.c});
}

class Emojis extends ChangeNotifier {
  List<Emoji> emojis;
  late SharedPreferences _prefs;

  Emojis({required this.emojis}) {
    setup();
  }

  setup() async {
    _prefs = await SharedPreferences.getInstance();
    load();
  }

  save() {
    _prefs.setStringList("e", emojis.map((i) => i.e).toList());
    emojis.forEachIndexed((index, element) {
      _prefs.setStringList(
          index.toString(), element.c.map((e) => e.toString()).toList());
    });
  }

  load() async {
    var e = _prefs.getStringList("e")?.toList() ?? List.of({});
    List<List<String>> c = List.of({});
    e.forEachIndexed((index, element) {
      var k = _prefs.getStringList(index.toString());
      c.add(k!);
    });
    debugPrint(c.toString());
    e.toList().forEachIndexed((index, element) {
      emojis.add(Emoji(
          e: element, c: c[index].map((e) => DateTime.parse(e)).toList()));
    });

    notifyListeners();
  }

  clickEmoji(int index) {
    emojis[index].c.add(DateTime.now());
    save();
    notifyListeners();
  }

  addEmoji(String e) {
    emojis.add(Emoji(e: e, c: List.of({})));
    save();
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Emojis(emojis: List.of([])),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var showEmojiKey = false;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<Emojis>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        child: Icon(showEmojiKey ? Icons.arrow_downward : Icons.plus_one),
        onPressed: () {
          setState(() {
            showEmojiKey = !showEmojiKey;
          });
        },
      ),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    title: const Text(
                      " ",
                    ),
                    toolbarHeight: MediaQuery.of(context).size.height / 3,
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          200,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return EmojiWidget(
                          index: index,
                        );
                      },
                      childCount: p.emojis.length,
                    ),
                  )
                ],
              ),
            ),
          ),
          EmojiKeyboard(showEmojiKey: showEmojiKey, p: p),
        ],
      ),
    );
  }
}

class EmojiKeyboard extends StatelessWidget {
  const EmojiKeyboard({
    Key? key,
    required this.showEmojiKey,
    required this.p,
  }) : super(key: key);

  final bool showEmojiKey;
  final Emojis p;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: (showEmojiKey == true) ? Offset(0, 0) : Offset(0, 1),
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Flexible(flex: 2, child: Container()),
          Flexible(
              flex: 1,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  p.addEmoji(emoji.emoji);
                },
              ))
        ]),
      ),
    );
  }
}

class EmojiWidget extends StatelessWidget {
  final int index;

  const EmojiWidget({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = context.watch<Emojis>();
    return GestureDetector(
      onTap: () {
        p.clickEmoji(index);
      },
      child: Stack(
        children: [
          Center(
            child: Text(
              p.emojis[index].e,
              style: const TextStyle(fontSize: 70),
            ),
          ),
          Center(
              child: BorderedText(
            strokeColor: Colors.white,
            child: Text(
              p.emojis[index].c.length.toString(),
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900),
            ),
          ))
        ],
      ),
    );
  }
}
