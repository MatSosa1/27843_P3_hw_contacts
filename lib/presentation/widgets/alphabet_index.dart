import 'package:flutter/material.dart';

class AlphabetIndex extends StatelessWidget {
  const AlphabetIndex({super.key});

  @override
  Widget build(BuildContext context) {
    const letters = [
      'A','B','C','D','E','F','G','H','I','J','K','L','M',
      'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
    ];

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters
            .map(
              (l) => Text(
                l,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
