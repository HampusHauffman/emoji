import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'emoji.dart';

class EmojiKeyboard extends StatelessWidget {
  const EmojiKeyboard({
    Key? key,
    required this.showEmojiKey,
  }) : super(key: key);

  final bool showEmojiKey;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<EmojiProvider>();

    return AnimatedSlide(
      offset: (showEmojiKey == true) ? const Offset(0, 0) : const Offset(0, 1),
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
