import 'package:flutter/material.dart';

import './about.dart';

class Settings extends StatefulWidget {
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final List _screens = [];
  final List<Map> _screensData = [
    {'title': 'About', 'screen': About()}
  ];

  SettingsState() {
    _addScreens();
  }

  _addScreens() {
    for (int i = 0; i < _screensData.length; i++) {
      _screens.add(GestureDetector(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => _screensData[i]['screen']));
        }),
        child: Text('${_screensData[i]['title']}'),
      ));
    }
  }

  build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView.separated(
          itemCount: _screens.length,
          separatorBuilder: (context, index) => Divider(
                color: Theme.of(context).primaryColorLight,
              ),
          itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(left: 10.0), child: _screens[index])),
    ));
  }
}
