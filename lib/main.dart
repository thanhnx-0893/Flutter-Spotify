import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'artists.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.white,
  ));
  runApp(FlutterSpotifyApp());
}

class FlutterSpotifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[300],
        primaryIconTheme: IconThemeData(
          color: Colors.white,
        ),
        primaryTextTheme: Typography(
          platform: TargetPlatform.iOS,
        ).white,
        scaffoldBackgroundColor: Color.fromRGBO(23, 23, 23, 1),
      ),
      home: Artists(),
    );
  }
}
