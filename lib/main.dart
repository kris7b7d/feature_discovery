import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() => runApp(FeatureDiscoveryApp());

class FeatureDiscoveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feature discovery',
      home: HomeScreen(title: 'Feature discovery'),
      theme: ThemeData(
        primaryColor: Colors.green,
        brightness: Brightness.dark,
      ),
    );
  }
}
