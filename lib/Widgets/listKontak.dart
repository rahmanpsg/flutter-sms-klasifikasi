import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/controllers/sms_controller.dart';
import 'package:sms_classification/models/kontak_moder.dart';
import 'package:sms_classification/routes/app_pages.dart';
import 'package:sms_classification/styles/constant.dart';

class ListKontak extends StatelessWidget {
  const ListKontak({Key? key, required this.contact}) : super(key: key);

  final KontakModel contact;

  @override
  Widget build(BuildContext context) {
    SmsController _smsController = Get.find<SmsController>();

    return InkWell(
      onTap: () {
        if (contact.telp.length > 1)
          Get.defaultDialog(
              title: "Pilih Nomor Tujuan",
              titleStyle: kHeaderStyle,
              radius: 0,
              content: Column(
                children: [
                  ...contact.telp
                      .map(
                        (t) => CheckboxListTile(
                          title: Text(t),
                          value: false,
                          onChanged: ((_) {
                            Get.back();
                            Get.toNamed(
                              Routes.pesan,
                              arguments: {
                                'index': _smsController.getIndexListMessage(t),
                                'contact': contact,
                              },
                            );
                          }),
                        ),
                      )
                      .toList()
                ],
              ));
        else
          Get.toNamed(
            Routes.pesan,
            arguments: {
              'index': _smsController.getIndexListMessage(
                contact.telp.first,
              ),
              'contact': contact,
            },
          );
      },
      highlightColor: Colors.transparent,
      child: ListTile(
        title: contact.nama.split(' ')[0] == 'Kirim'
            ? Row(
                children: <Widget>[
                  Text('Kirim ke '),
                  Text(
                    contact.nama.split(' ')[2],
                    style: TextStyle(
                      color: dangerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(contact.nama),
        subtitle: Text(
          contact.telp.first +
              (contact.telp.length > 1
                  ? ' (+${contact.telp.length - 1} lainnya)'
                  : ''),
        ),
        trailing: Text(
          contact.label.toString(),
          style: kHintStyle.copyWith(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
