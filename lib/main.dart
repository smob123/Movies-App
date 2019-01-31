import 'package:flutter/material.dart';

import './screens/trending.dart';
import './screens/searchScreen.dart';

main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> screens = new List<Widget>();
  int _bottomNavBarIndex = 0;

  @override
  initState() {
    super.initState();
    screens.addAll([TrendingMovies(), SearchScreen(), Container()]);
  }

  _onBottomNavBarItemTabbed(int index) {
    setState(() {
      _bottomNavBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Movies App'),
            backgroundColor: Colors.blueGrey,
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black54,
            ),
            child: BottomNavigationBar(
              onTap: _onBottomNavBarItemTabbed,
              currentIndex: _bottomNavBarIndex,
              fixedColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up),
                  title: Text('Trending'),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), title: Text('Search')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), title: Text('Favourites')),
              ],
            ),
          ),
          body: Container(color: Colors.grey, child: screens[_bottomNavBarIndex])),
    );
  }
}
