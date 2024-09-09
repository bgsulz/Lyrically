import 'package:flutter/material.dart';
import 'package:lyrically/game.dart';
import 'package:lyrically/lyrics.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class SongSearchBar extends StatelessWidget {
  const SongSearchBar({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);

    return SearchField(
      searchStyle: Theme.of(context).textTheme.bodyMedium,
      searchInputDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Guess a song...',
      ),
      hint: 'Guess a song...',
      dynamicHeight: true,
      maxSuggestionBoxHeight: 180,
      suggestions: Lyrics.allSongs
          .map((element) => SearchFieldListItem<String>(element.toString()))
          .toList(),
      animationDuration: Duration.zero,
      onSubmit: (String selection) {
        gameState.submitGuess();
      },
      controller: gameState.guessController,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final gameState = Provider.of<GameState>(context, listen: false);

  //   return LayoutBuilder(
  //     builder: (context, constraints) => Autocomplete<String>(
  //       // optionsViewOpenDirection: OptionsViewOpenDirection.up,
  //       optionsMaxHeight: 100,
  //       fieldViewBuilder:
  //           (context, textEditingController, focusNode, onFieldSubmitted) {
  //         return Consumer<GameState>(
  //           builder: (context, gameState, child) {
  //             gameState.guessText = "";
  //             textEditingController.text = "";
  //             return TextField(
  //               scrollPadding: const EdgeInsets.only(bottom: 40),
  //               controller: textEditingController,
  //               focusNode: focusNode,
  //               decoration: const InputDecoration(
  //                 border: OutlineInputBorder(),
  //                 hintText: 'Guess a song...',
  //               ),
  //               style: Theme.of(context).textTheme.bodyMedium,
  //               onChanged: (value) => (BuildContext context, String value) {
  //                 // print("Changed to: " + value);
  //                 gameState.guessText = value;
  //               }(context, value),
  //             );
  //           },
  //         );
  //       },
  //       optionsViewBuilder: (context, onSelected, options) => Align(
  //         alignment: Alignment.topLeft,
  //         child: Material(
  //           elevation: 4,
  //           color: Theme.of(context).colorScheme.surfaceContainer,
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
  //           ),
  //           // child: ConstrainedBox(
  //           //   constraints: BoxConstraints(maxWidth: constraints.biggest.width),
  //           child: ListView.builder(
  //             padding: EdgeInsets.zero,
  //             itemCount: options.length,
  //             shrinkWrap: false,
  //             itemBuilder: (BuildContext context, int index) {
  //               final String option = options.elementAt(index);
  //               return InkWell(
  //                 onTap: () => onSelected(option),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Text(option),
  //                 ),
  //               );
  //             },
  //           ),
  //           // ),
  //         ),
  //       ),
  //       optionsBuilder: (textEditingValue) => Lyrics.allSongs
  //           .map((element) => element.toString())
  //           .where((element) => element
  //               .toLowerCase()
  //               .contains(textEditingValue.text.toLowerCase()))
  //           .toList(),
  //       onSelected: (option) => (BuildContext context, String value) {
  //         // print("Changed to: " + value);
  //         gameState.guessText = value;
  //       }(context, option),
  //     ),
  //   );
  // }
}
