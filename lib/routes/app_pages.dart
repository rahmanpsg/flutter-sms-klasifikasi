import 'package:get/get.dart';
import 'package:sms_classification/screens/tentang.dart';
import 'package:sms_classification/screens/home.dart';
import 'package:sms_classification/screens/pesan.dart';
import 'package:sms_classification/screens/pesan_baru.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: Routes.pesan,
      page: () => PesanScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.pesanBaru,
      page: () => PesanBaruScreen(),
    ),
    GetPage(
      name: Routes.about,
      page: () => TentangScreen(),
    ),
  ];
}
