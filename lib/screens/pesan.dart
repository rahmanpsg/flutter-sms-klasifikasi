import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/controllers/sms_controller.dart';
import 'package:sms_classification/models/kontak_moder.dart';
import 'package:sms_classification/models/list_sms_model.dart';
import 'package:sms_classification/models/sms_model.dart';
import 'package:sms_classification/styles/constant.dart';
import 'package:telephony/telephony.dart';

import '../utils/format_indonesia.dart';

class PesanScreen extends StatelessWidget {
  const PesanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SmsController _smsController = Get.find<SmsController>();
    int _listMessageActive = Get.arguments['index'];
    _smsController.listMessageActive = _listMessageActive;

    _smsController.smsTfController.clear();

    // jika index -1 maka membuat pesan baru
    if (_listMessageActive == -1) {
      KontakModel contact = Get.arguments['contact'];
      _smsController.createNewSms(contact);
    }

    ListSmsModel _listSms =
        _smsController.listMessage[_smsController.listMessageActive];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _smsController.encodeContact(_listSms.sender),
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
                    itemCount: _listSms.messages.length,
                    shrinkWrap: true,
                    reverse: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      final SmsModel sms = _listSms.messages[index];

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
                                        color: iconColor[sms.predict.tipe],
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
            _smsController.checkIsNumber(sender: _listSms.sender)
                ? Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _smsController.smsTfController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: 'Pesan teks',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _smsController.sendSms(
                              _listSms.sender,
                            );
                          },
                          icon: Icon(
                            Icons.send,
                            color: dangerColor,
                          ),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Pengirim tidak mendukung balasan'),
                  ),
          ],
        ),
      ),
    );
  }
}
