import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          'Flutter Prep',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
        ),
        SizedBox(height: 2),
        Text(
          'Notes • Interview Prep • Offline',
          style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 92, 43, 135), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

