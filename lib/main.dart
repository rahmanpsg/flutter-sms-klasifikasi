import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/routes/app_pages.dart';
import 'package:sms_classification/themes/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.basic,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
