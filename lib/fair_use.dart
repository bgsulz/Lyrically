import 'package:flutter/material.dart';

class FairUse {
  static const String _header = 'Lyrically operates under '
      'the principle of fair use as established in the Copyright Act of 1976, '
      '17 U.S.C. § 107.';

  static const String _list =
      'We believe our use of lyrics falls under fair use for these reasons:\n'
      '\t\t\t1. Our game is transformative in nature.'
      'We use small fragments of lyrics -- constituting a small fraction of '
      'the original copyrighted work -- in a scrambled order. The primary purpose is '
      'a fun trivia game that tests and enhances players\' knowledge of music.\n'
      '\t\t\t2. Our game does not serve as a replacement for the '
      'original songs or complete lyrics. In fact, it may encourage users to '
      'seek out the full songs or lyrics to the benefit of the '
      'copyright holders.';

  static const String _footer = 'We effort to properly attribute '
      'lyrics to their copyright holders. This game is not '
      'intended to infringe upon any copyrights. If you are a copyright holder '
      'and believe that your work has been used in a way that constitutes '
      'copyright infringement, click the button below to contact us. We will promptly '
      'address your concerns and comply with any takedown requests.\n\n'
      'This statement is for informational purposes only and does not '
      'constitute legal advice. We reserve the right to modify this '
      'statement as necessary.';

  static List<Widget> text() {
    return [
      const Text(_header),
      const SizedBox(height: 16),
      const Text(_list),
      const SizedBox(height: 16),
      const Text(_footer),
    ];
  }
}
