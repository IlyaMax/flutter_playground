import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BeamerDelegate _routerDelegate;

  MyApp({super.key})
      : _routerDelegate = BeamerDelegate(
          initialPath: '/',
          locationBuilder: RoutesLocationBuilder(routes: {
            '/': (p0, p1, p2) {
              return const MyHomePage(title: 'Flutter Demo Home Page');
            },
            '/second': (p0, p1, p2) {
              return const _SecondScreen();
            }
          }),
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerDelegate: _routerDelegate,
      routeInformationParser: BeamerParser(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  const _SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios_rounded),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _pushScreen() {
    Beamer.of(context).beamToNamed('/second');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
