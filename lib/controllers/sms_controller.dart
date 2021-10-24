import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sms_classification/classifier.dart';
import 'package:sms_classification/models/list_sms_model.dart';
import 'package:sms_classification/models/predict_model.dart';
import 'package:sms_classification/models/sms_model.dart';
import 'package:telephony/telephony.dart';

import '../format_indonesia.dart';

class SmsController extends GetxController with Classifier {
  final Telephony _telephony = Telephony.instance;
  // final SmsQuery _query = SmsQuery();

  late List<ListSmsModel> listMessage = [];
  late List<SmsMessage> _messagesInbox;
  late List<SmsMessage> _messagesSent;

  // int listMessagePrevActive = 0;
  late int listMessageActive;

  final isLoading = true.obs;

  late TextEditingController tfController;

  final Map<String, String> kontak = {};

  @override
  void onInit() async {
    super.onInit();

    await getAllContacts();

    await loadModel();
    await loadTokenizer();

    await getAllSms();
    await groupSms();

    tfController = TextEditingController();
  }

  Future getAllContacts() async {
    try {
      List<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      contacts.forEach((contact) {
        String nama = contact.displayName ?? '';
        String nomor =
            contact.phones!.length > 0 ? contact.phones![0].value ?? '' : '';

        kontak.addIf(contact.phones!.length > 0, nomor, nama);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  String encodeContact(String number) {
    return kontak.containsKey(number) ? kontak[number] ?? number : number;
  }

  void listener(SendStatus status) {
    try {
      String body = tfController.text;
      DateTime date = DateTime.now();

      // if (status == SendStatus.SENT) {}
      if (status == SendStatus.DELIVERED) {
        tfController.clear();
        listMessage[listMessageActive].date = date;
        listMessage[listMessageActive].messages.insert(
              0,
              SmsModel(
                body: body,
                date: date,
                type: SmsType.MESSAGE_TYPE_SENT,
                predict: PredictModel(tipe: 3, tipeDecode: '', confidence: ''),
              ),
            );

        listMessage.sort((a, b) => b.date.compareTo(a.date));

        listMessageActive = 0;

        update();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void sendSms(String to) {
    try {
      _telephony.sendSms(
        to: to,
        message: tfController.text,
        statusListener: listener,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future getAllSms() async {
    _messagesInbox = await _telephony.getInboxSms(columns: [
      SmsColumn.THREAD_ID,
      SmsColumn.ADDRESS,
      SmsColumn.BODY,
      SmsColumn.DATE,
      SmsColumn.TYPE,
    ]);
    _messagesSent = await _telephony.getSentSms(columns: [
      SmsColumn.THREAD_ID,
      SmsColumn.ADDRESS,
      SmsColumn.BODY,
      SmsColumn.DATE,
      SmsColumn.TYPE,
    ]);
    update();
  }

  Future groupSms() async {
    try {
      // Membuat list berdasarkan key dari semua threadID Sms
      List<int> keys = [];
      _messagesInbox.forEach((msg) {
        keys.add(msg.threadId ?? 0);
      });

      // Mengelompokkan list berdasarkan threadID yang sama
      [...keys.toSet()].forEach((k) {
        List<SmsMessage> sms = [
          ..._messagesInbox.where((msg) => msg.threadId == k),
          ..._messagesSent.where((msg) => msg.threadId == k),
        ];

        List<SmsModel> list = [
          ...sms.map((s) {
            // Periksa jika dari nomor baru maka akan diprediksi
            PredictModel _predict =
                PredictModel(tipe: 3, tipeDecode: '', confidence: '100');

            if (s.address!.contains(new RegExp(r'[0-9]')) &&
                s.address!.length > 6) {
              _predict = predict(s.body ?? '');
            }

            return SmsModel(
              // threadID: s.threadId ?? 0,
              // sender: s.address ?? '-',
              body: s.body ?? '-',
              date: DateTime.fromMillisecondsSinceEpoch(s.date ?? 0),
              type: s.type,
              predict: _predict,
            );
          })
        ];

        list.sort((a, b) => b.date.compareTo(a.date));

        //
        listMessage.add(ListSmsModel(
          threadID: sms.first.threadId ?? 0,
          sender: sms.first.address ?? '',
          date: list.first.date,
          messages: list,
        ));

        listMessage.sort((a, b) => b.date.compareTo(a.date));
      });

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  String timeAgo(DateTime date) {
    DateTime now = DateTime.now();

    int hari = DateTime(date.year, date.month, date.day).difference(now).inDays;

    if (hari == 0) {
      final format = DateFormat.Hm();
      return format.format(date);
    } else if (hari >= -7) {
      return Waktu(date).format('E');
    }

    return Waktu(date).format('d MMM');
  }
}