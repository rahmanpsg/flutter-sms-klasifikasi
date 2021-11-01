import 'package:flutter/material.dart';
import 'package:sms_classification/styles/constant.dart';

class AppTheme {
  static ThemeData get basic => ThemeData(
        colorScheme: ColorScheme.light().copyWith(
          primary: primaryColor,
        ),
        splashColor: secondaryColor,
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          titleTextStyle: kHeaderStyle,
          iconTheme: IconThemeData(color: dangerColor),
        ),
      );
}
