import 'package:flutter/material.dart';
import 'package:media/ui/homeScreen.dart';
void main() {
  runApp(MaterialApp(
    home: homeScreen(),
    theme: CustomThemeData(),
  ));
}

ThemeData CustomThemeData() {
  return ThemeData(
      primaryColor: Color(0xFF0097A7),
    buttonColor: Color(0xFF0097A7)
  );
}

