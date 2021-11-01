import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/Widgets/listSms.dart';
import 'package:sms_classification/controllers/sms_controller.dart';
import 'package:sms_classification/models/sms_model.dart';
import 'package:sms_classification/routes/app_pages.dart';
import 'package:sms_classification/styles/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SMS Klasifikasi',
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.about);
            },
            child: Icon(
              Icons.info,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.pesanBaru);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: dangerColor),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GetBuilder<SmsController>(
                init: SmsController(),
                builder: (smsController) {
                  return smsController.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: dangerColor,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 8),
                          itemCount: smsController.listMessage.length,
                          itemBuilder: (_, index) {
                            SmsModel message =
                                smsController.listMessage[index].messages.first;
                            return ListSms(
                              sms: message,
                              index: index,
                            );
                          });
                }),
          ),
        ],
      ),
    );
  }
}
