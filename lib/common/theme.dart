import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';

Map<int, Color> colorCodes = {
  50: Color.fromRGBO(5, 55, 136, .1),
  100: Color.fromRGBO(33, 37, 48, .2),
  200: Color.fromRGBO(33, 37, 48, .3),
  300: Color.fromRGBO(33, 37, 48, .4),
  400: Color.fromRGBO(33, 37, 48, .5),
  500: Color.fromRGBO(33, 37, 48, .6),
  600: Color.fromRGBO(33, 37, 48, .7),
  700: Color.fromRGBO(33, 37, 48, .8),
  800: Color.fromRGBO(33, 37, 48, .9),
  900: Color.fromRGBO(33, 37, 48, 1),
};

MaterialColor customColor = MaterialColor(0xFF053788, colorCodes);
final appTheme = ThemeData(
  fontFamily: "Montserrat",
  primarySwatch: customColor,
  scaffoldBackgroundColor: ORColorStyles.white,
  textTheme: TextTheme(),
  appBarTheme: AppBarTheme(
    color: ORColorStyles.primary_blue,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: ORColorStyles.white,
    ),
  ),
);
