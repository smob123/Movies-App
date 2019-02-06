import 'package:flutter/material.dart';

import './screens/homeScreen.dart';

main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColorDark: Color.fromARGB(255, 29, 29, 39),
        primaryColorLight: Colors.white70,
        hintColor: Colors.white70,
        scaffoldBackgroundColor: Color.fromARGB(255, 29, 29, 39),
        fontFamily: 'Yantramanav',
        textTheme: TextTheme(
            headline: TextStyle(
                color: Colors.white70,
                fontFamily: 'Montserrat',
                fontSize: 25.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600),
            title: TextStyle(
              color: Colors.white70,
              fontSize: 18.0,
              letterSpacing: 0.5,
            ),
            body1: TextStyle(
              color: Colors.white70,
              fontSize: 18.0,
              letterSpacing: 0.5,
            ),
            body2: TextStyle(
              color: Colors.white70,
              fontSize: 18.0,
              letterSpacing: 0.5,
            )),
      ),
      home: SafeArea(child: HomeScreen()),
    );
  }
}
