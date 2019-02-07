import 'package:flutter/material.dart';

import './config/appTheme.dart';
import './screens/homeScreen.dart';

main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme().mainTheme(),
      home: SafeArea(child: HomeScreen()),
    );
  }
}
