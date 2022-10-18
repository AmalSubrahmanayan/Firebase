import 'package:flutter/material.dart';

class ShowSnackBar {
  showSnackBar(context, Color color, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(text),
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }
}
