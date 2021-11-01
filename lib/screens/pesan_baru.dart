import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/Widgets/listKontak.dart';
import 'package:sms_classification/controllers/sms_controller.dart';
import 'package:sms_classification/models/kontak_moder.dart';
import 'package:sms_classification/styles/constant.dart';

class PesanBaruScreen extends StatelessWidget {
  const PesanBaruScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SmsController _smsController = Get.find<SmsController>();
    List<KontakModel> _contacts = _smsController.contacts;
    List<KontakModel> _searchContacts = _smsController.searchContacts;
    _smsController.searchTfController.clear();
    _searchContacts.clear();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pesan baru",
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
                    controller: _smsController.searchTfController,
                    onChanged: ((text) => _smsController.searchContact(text)),
                    decoration: const InputDecoration(
                      hintText: 'Ketik nama atau nomor telepon',
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          Obx(() => Expanded(
                child: _searchContacts.isNotEmpty ||
                        _smsController.searchTfController.text.isNotEmpty
                    ? ListView.builder(
                        itemCount: _searchContacts.length,
                        itemBuilder: (_, index) {
                          return ListKontak(contact: _searchContacts[index]);
                        },
                      )
                    : ListView.builder(
                        itemCount: _contacts.length,
                        itemBuilder: (_, index) {
                          return ListKontak(contact: _contacts[index]);
                        },
                      ),
              ))
        ],
      ),
    );
  }
}
