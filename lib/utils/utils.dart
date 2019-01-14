import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class Utils {
  static showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static String convertDuration(int durationInMilisecond) {
    int minute = ((durationInMilisecond / 1000) / 60).round();
    int second = ((durationInMilisecond / 1000) % 60).round();
    return sprintf("%d:%02d", [minute, second]);
  }

  static String convertLargeNumber(int number) {
    if (number >= 1000000000) {
      double value = number / 1000000000;
      return sprintf("%.1fb", [value]);
    } else if (number >= 1000000) {
      double value = number / 1000000;
      return sprintf("%.1fm", [value]);
    } else if (number >= 1000) {
      return "${(number / 1000).round()}k";
    } else {
      return "${number}";
    }
  }
}
