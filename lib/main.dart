import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/home.dart';
import 'screens/pesan_baru.dart';
import 'screens/pesan.dart';
import 'styles/constant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.isFirst = true}) : super(key: key);
  final isFirst;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        // primaryColor: primaryColor,
        colorScheme: ColorScheme.light().copyWith(
          primary: primaryColor,
        ),
        splashColor: secondaryColor,
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              brightness: Brightness.dark,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(
          name: '/pesan',
          page: () => PesanScreen(),
          transition: Transition.cupertino,
        ),
        GetPage(name: '/pesanbaru', page: () => PesanBaruScreen()),
      ],
    );
  }
}
