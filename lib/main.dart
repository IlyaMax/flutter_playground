import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  final routerDelegate = BeamerDelegate(
    initialPath: '/home',
    locationBuilder: RoutesLocationBuilder(
      routes: {'/home': (_, __, ___) => HomeScreen()},
    ),
  );
  runApp(MaterialApp.router(
    routeInformationParser: BeamerParser(),
    routerDelegate: routerDelegate,
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: strict_raw_type
  List<Tab> _tabs = [];
  int _currentTabIndex = 0;
  List<BeamerDelegate> _nestedRouterDelegates = [];
  late BeamerDelegate _homeRouterDelegate;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = 0;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Beamer(routerDelegate: _homeRouterDelegate),
          ),
          _BottomBar(
            tabs: _tabs,
            onTabPressed: (index) {
              if (index == _currentTabIndex) return;
              final destination = (index == 0)
                  ? '/tab1'
                  : (index == 1)
                      ? '/tab2'
                      : '/tab3';
              _homeRouterDelegate.beamToNamed(destination);
            },
            currentTabIndex: _currentTabIndex,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _homeRouterDelegate.beamToNamed('/tab2');
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tabs.isEmpty) {
      _tabs = [
        Tab(
          MockScreenLocation('tab1'),
          Icons.book,
          'tab1',
        ),
        Tab(
          MockScreenLocation('tab2'),
          Icons.article,
          'tab2',
        ),
        Tab(
          MockScreenLocation('tab3'),
          Icons.cabin,
          'tab3',
        ),
      ];
      _nestedRouterDelegates = _tabs
          .map((tab) => BeamerDelegate(locationBuilder: (routeInformation, _) {
                return tab.rootLocation;
              }))
          .toList();
      _homeRouterDelegate = BeamerDelegate(
        initialPath: '/tab1',
        locationBuilder: RoutesLocationBuilder(
          routes: {
            '/tab1': (context, state, _) =>
                Beamer(routerDelegate: _nestedRouterDelegates[0]),
            '/tab2': (context, state, _) =>
                Beamer(routerDelegate: _nestedRouterDelegates[1]),
            '/tab3': (context, state, _) =>
                Beamer(routerDelegate: _nestedRouterDelegates[2]),
          },
        ),
      );
      _homeRouterDelegate.addListener(_updateCurrentTabIndex);
    }
  }

  @override
  void dispose() {
    for (final delegate in _nestedRouterDelegates) {
      delegate.dispose();
    }
    _homeRouterDelegate
      ..removeListener(_updateCurrentTabIndex)
      ..dispose();
    super.dispose();
  }

  void _updateCurrentTabIndex() {
    final currentLoc = _homeRouterDelegate.configuration.location;
    setState(() {
      _currentTabIndex = currentLoc == '/tab1'
          ? 0
          : currentLoc == '/tab2'
              ? 1
              : 2;
    });
  }
}

class _BottomBar extends StatelessWidget {
  // ignore: strict_raw_type
  final List<Tab> tabs;
  final int currentTabIndex;
  final void Function(int index) onTabPressed;
  const _BottomBar({
    Key? key,
    required this.tabs,
    required this.onTabPressed,
    required this.currentTabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50,
      child: Row(
        children: tabs
            .mapIndexed(
              (index, tab) => Expanded(
                child: _BottomBarItem(
                  isSelected: index == currentTabIndex,
                  icon: tab.icon,
                  title: tab.title,
                  onPressed: () => onTabPressed(index),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;
  const _BottomBarItem({
    Key? key,
    required this.isSelected,
    required this.icon,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.blue[700] : Colors.blue;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class Tab {
  final BeamLocation rootLocation;
  final IconData icon;
  final String title;

  const Tab(this.rootLocation, this.icon, this.title);
}

class MockScreenLocation extends BeamLocation<BeamState> {
  final String title;

  MockScreenLocation(this.title);
  @override
  List<Pattern> get pathPatterns => [RegExp(r'/.*mock\?title=.*')];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: MockScreen(title: title))];
  }
}

class MockScreen extends StatefulWidget {
  final String title;
  const MockScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<MockScreen> createState() => _MockScreenState();
}

class _MockScreenState extends State<MockScreen> {
  late Future<String> stringFuture;
  @override
  void initState() {
    super.initState();
    stringFuture = Future.delayed(Duration(seconds: 1), () => widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
          future: stringFuture,
          builder: (context, snapshot) {
            if (snapshot.data == null) return CircularProgressIndicator.adaptive();
            return Text(widget.title);
          }
        ),
      ),
    );
  }
}
