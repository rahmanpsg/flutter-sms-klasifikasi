import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/controllers/sms_controller.dart';
import 'package:sms_classification/models/sms_model.dart';
import 'package:sms_classification/styles/constant.dart';
import 'package:telephony/telephony.dart';

import '../format_indonesia.dart';

class PesanScreen extends StatelessWidget {
  const PesanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SmsController smsController = Get.find<SmsController>();
    int listMessageActive = Get.arguments;
    smsController.listMessageActive = listMessageActive;
    List<SmsModel> listSms =
        smsController.listMessage[listMessageActive].messages;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dangerColor),
        title: Text(
          smsController.encodeContact(
              smsController.listMessage[listMessageActive].sender),
          style: kHeaderStyle,
        ),
      ),
      body: Container(
        color: bgColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: GetBuilder<SmsController>(
                builder: (smsController) {
                  return ListView.builder(
                    itemCount: listSms.length,
                    shrinkWrap: true,
                    reverse: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      final SmsModel sms = listSms[index];

                      return Container(
                        padding: EdgeInsets.only(
                          left: 14,
                          right: 14,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            Text(
                              Waktu(sms.date).format('EEEE, d MMM • h:mm a'),
                              textAlign: TextAlign.center,
                            ),
                            Align(
                              alignment: (sms.type == SmsType.MESSAGE_TYPE_INBOX
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (sms.type == SmsType.MESSAGE_TYPE_SENT
                                      ? Colors.grey.shade200
                                      : secondaryColor),
                                ),
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  sms.body,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            if (sms.predict.tipe != 3)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        size: 16,
                                        color: redColor,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'Pesan ini terindikasi SPAM (${sms.predict.tipeDecode} ${sms.predict.confidence}%)',
                                        style: kHintStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: smsController.tfController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Pesan teks',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      smsController.sendSms(
                        smsController.listMessage[listMessageActive].sender,
                      );
                    },
                    icon: Icon(
                      Icons.send,
                      color: dangerColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
