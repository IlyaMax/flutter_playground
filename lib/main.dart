import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: DefaultSvgTheme(
            theme: const SvgTheme(currentColor: Colors.green),
            child: SvgPicture.network(
              'https://www.svgrepo.com/show/111233/network.svg',
            ),
          ),
        ),
      ),
    ),
  );
}
