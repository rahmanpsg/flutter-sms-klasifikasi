import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:sms_classification/styles/constant.dart';

class ListKontak extends StatelessWidget {
  const ListKontak({Key? key, required this.contact}) : super(key: key);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    String nama = contact.displayName ?? '-';
    List<Item> telp = contact.phones ?? [];

    telp.forEach((element) {
      log(element.label.toString());
      log(element.value.toString());
    });

    if (telp.isNotEmpty)
      return ListTile(
        title: Text(nama),
        subtitle: Text(telp.first.value.toString()),
        trailing: Text(
          telp.first.label.toString(),
          style: kHintStyle.copyWith(
            fontSize: 12,
          ),
        ),
      );

    return Container();
  }
}
