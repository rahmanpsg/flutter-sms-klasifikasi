import 'package:flutter/material.dart';

// Colors
const primaryColor = Color(0xFFC2FAF1);
const secondaryColor = Color(0xFFDFEFF0);
const dangerColor = Color(0xFF295E6A);
const bgColor = Color(0xFFF6F6F6);
const yellowColor = Color(0xFFf5f522);
const orangeColor = Color(0xFFffbd2e);
const greenColor = Color(0xFF4bd662);
const blueColor = Color(0xFF22e3f5);
const redColor = Color(0xFFf7052e);

// Text Style
const primaryStyle = TextStyle(fontFamily: 'Poppins', fontSize: 14);
const kLabelStyle =
    TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white);
const kHintStyle =
    TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black54);
const kHeaderStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  color: dangerColor,
  fontWeight: FontWeight.bold,
);
const secondaryStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryColor);

final kBoxDecorationStyle = BoxDecoration(
  color: primaryColor,
  borderRadius: BorderRadius.circular(25.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
