import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/Widgets/listSms.dart';
import 'package:sms_classification/controllers/sms_controller.dart';
import 'package:sms_classification/models/sms_model.dart';
import 'package:sms_classification/styles/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SMS Klasifikasi',
          style: kHeaderStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/pesanbaru');
        },
        child: const Icon(Icons.add),
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
