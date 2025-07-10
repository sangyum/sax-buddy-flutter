import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  const SubTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Great job! We\'ve analyzed your performance and are ready to create your personalized practice routine.',
      style: TextStyle(
        fontSize: 16,
        color: Color(0xFF757575),
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }
}
