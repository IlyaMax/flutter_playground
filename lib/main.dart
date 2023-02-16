import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async => throw Exception('TEST EXCEPTION'),
          child: const SizedBox.square(dimension: 30),
        ),
      ),
    );
  }
}
