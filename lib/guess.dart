enum Guess { skip, incorrect, sameArtist, correct }

class GuessInfo {
  static String summarize(List<Guess> guesses, {bool isBlackAndWhite = false}) {
    var emojis = guesses.map((guess) {
      switch (guess) {
        case Guess.skip:
          return isBlackAndWhite ? '⇒' : '⬛';
        case Guess.incorrect:
          return isBlackAndWhite ? '⧅' : '🟥';
        case Guess.sameArtist:
          return isBlackAndWhite ? '⧆' : '🟨';
        case Guess.correct:
          return isBlackAndWhite ? '☆' : '🟩';
      }
    }).toList();
    while (emojis.length < 5) {
      emojis.add(isBlackAndWhite ? '○' : '⬜');
    }
    var quantity = guesses.length == 5 && guesses[4] != Guess.correct
        ? "X"
        : guesses.length.toString();
    return "${'$quantity/5'} [${emojis.join('')}]";
  }
}
