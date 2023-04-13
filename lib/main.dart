import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: [
          GoRoute(
            path: 'second',
            builder: (context, state) => const _SecondScreen(),
          ),
        ],
      ),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: _router,
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
    GoRouter.of(context).go('/second');
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
