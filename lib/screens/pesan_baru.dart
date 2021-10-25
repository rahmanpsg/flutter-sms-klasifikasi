import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/Widgets/listKontak.dart';
import 'package:sms_classification/controllers/sms_controller.dart';
import 'package:sms_classification/styles/constant.dart';

class PesanBaruScreen extends StatelessWidget {
  const PesanBaruScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SmsController smsController = Get.find<SmsController>();
    List<Contact> contacts = smsController.contacts;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dangerColor),
        title: const Text(
          "Pesan baru",
          style: kHeaderStyle,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            decoration: kBoxDecorationStyle,
            child: Row(
              children: <Widget>[
                const Text("Kepada"),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    // controller: smsController.tfController,
                    decoration: const InputDecoration(
                        hintText: 'Ketik nama atau nomor telepon',
                        border: InputBorder.none),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (_, index) {
                return ListKontak(contact: contacts[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
