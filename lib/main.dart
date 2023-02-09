import 'package:bordered_text/bordered_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'emoji.dart';
import 'emoji_keyboard.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => EmojiProvider(emojis: []),
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
      title: 'Emoji counter',
      theme: ThemeData(
        //fontFamily: 'NotoColorEmoji',
        useMaterial3: true,
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
              child: const EmojiScrollView(),
            ),
          ),
          EmojiKeyboard(showEmojiKey: showEmojiKey),
        ],
      ),
    );
  }
}

class EmojiScrollView extends StatelessWidget {
  const EmojiScrollView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.watch<EmojiProvider>();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
            "EMOJI APP",
          ),
          toolbarHeight: MediaQuery.of(context).size.height / 3,
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          delegate: SliverChildBuilderDelegate(
            childCount: p.emojis.length,
            (BuildContext context, int index) {
              return EmojiWidget(
                index: index,
                key: Key(index.toString()),
                emoji: p.emojis[index],
              );
            },
          ),
        )
      ],
    );
  }
}

class EmojiWidget extends StatelessWidget {
  final int index;
  final Emoji emoji;

  const EmojiWidget({
    required this.index,
    required Key? key,
    required this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = context.watch<EmojiProvider>();
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return RemoveEmojiAlertDialog(p: p, index: index);
          },
        );
      },
      onTap: () {
        p.clickEmoji(index);
      },
      child: Stack(
        children: [
          Center(
            child: Text(
              emoji.emoji,
              style: const TextStyle(
                fontSize: 70,
                fontFamily: "NotoColorEmoji",
              ),
            ),
          ),
          Center(
              child: BorderedText(
            strokeColor: Colors.white,
            child: Text(
              emoji.count.length.toString(),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
            ),
          ))
        ],
      ),
    );
  }
}

class RemoveEmojiAlertDialog extends StatelessWidget {
  const RemoveEmojiAlertDialog({
    super.key,
    required this.p,
    required this.index,
  });

  final EmojiProvider p;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            p.removeEmoji(index);
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
      title: Text(
        "Delete:${p.emojis[index].emoji}??",
        style: const TextStyle(fontFamily: "NotoColorEmoji"),
      ),
    );
  }
}
