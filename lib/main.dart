import 'package:flutter/material.dart';
import 'artists.dart';

void main() => runApp(FlutterSpotifyApp());

class FlutterSpotifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Artists(),
    );
  }
}
