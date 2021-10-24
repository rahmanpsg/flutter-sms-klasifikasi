import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          // Add your onPressed code here!
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
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: smsController.listMessage.length,
                          itemBuilder: (_, index) {
                            SmsModel message =
                                smsController.listMessage[index].messages.first;
                            return listSms(
                              message,
                              index,
                            );
                          });
                }),
          ),
        ],
      ),
    );
  }
}

Widget listSms(SmsModel sms, int index) {
  SmsController smsController = Get.find<SmsController>();
  return InkWell(
    onTap: () {
      Get.toNamed("/pesan", arguments: index);
    },
    highlightColor: Colors.transparent,
    child: ListTile(
      // minLeadingWidth: 50,
      leading: SizedBox(
        width: 45,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            sms.predict.tipe != 3
                ? const Icon(
                    Icons.warning,
                    color: redColor,
                    size: 28,
                  )
                : const Icon(
                    Icons.chat,
                    color: dangerColor,
                    size: 28,
                  ),
            if (sms.predict.tipe != 3)
              Text(
                sms.predict.tipeDecode,
                style: kHintStyle,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      title: Text(
        smsController.encodeContact(smsController.listMessage[index].sender),
      ),
      subtitle: Text(
        sms.body,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        smsController.timeAgo(sms.date),
        style: kHintStyle.copyWith(
          fontSize: 12,
        ),
      ),
    ),
  );
}
