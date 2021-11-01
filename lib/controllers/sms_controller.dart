import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_classification/utils/classifier.dart';
import 'package:sms_classification/models/kontak_moder.dart';
import 'package:sms_classification/models/list_sms_model.dart';
import 'package:sms_classification/models/predict_model.dart';
import 'package:sms_classification/models/sms_model.dart';
import 'package:telephony/telephony.dart';

import '../utils/format_indonesia.dart';

class SmsController extends GetxController with Classifier {
  final Telephony _telephony = Telephony.instance;
  // final SmsQuery _query = SmsQuery();

  late List<ListSmsModel> listMessage = [];
  late List<SmsMessage> _messagesInbox;
  late List<SmsMessage> _messagesSent;

  // int listMessagePrevActive = 0;
  late int listMessageActive;

  final isLoading = true.obs;

  late TextEditingController smsTfController;
  late TextEditingController searchTfController;

  List<KontakModel> contacts = [];
  final Map<String, String> contact = {};
  final List<KontakModel> searchContacts = <KontakModel>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await loadModel();
    await loadTokenizer();

    if (await Permission.contacts.request().isGranted) {
      await getAllContacts();
    }

    if (await Permission.sms.request().isGranted) {
      await getAllSms();
    }

    await groupAndPredictSms();

    _telephony.listenIncomingSms(
      onNewMessage: newMessageHandler,
      listenInBackground: false,
    );

    smsTfController = TextEditingController();
    searchTfController = TextEditingController();
  }

  void newMessageHandler(SmsMessage message) {
    int indexList = getIndexListMessage(message.address.toString());
    if (indexList == -1) {
    } else {
      addNewMessage(
        date: DateTime.fromMillisecondsSinceEpoch(message.date ?? 0),
        body: message.body,
        type: message.type,
      );

      listMessageActive = 0;

      update();
    }
  }

  Future getAllContacts() async {
    try {
      List<Contact> _contacts =
          await ContactsService.getContacts(withThumbnails: false);
      _contacts.forEach((cont) {
        if (cont.phones!.length < 1) return;
        String nama = cont.displayName.toString();
        List<String> telp = [];
        String label = cont.phones!.first.label.toString();

        cont.phones!.forEach((phone) {
          String nomor = phone.value
              .toString()
              .replaceAll(new RegExp('[^+\\d]|(?<=.)\\+'), '');

          telp.add(nomor);

          contact.addIf(phone.value.toString() != '', nomor, nama);
        });

        KontakModel kontak =
            KontakModel(nama: nama, telp: telp.toSet().toList(), label: label);
        contacts.add(kontak);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void searchContact(String text) {
    searchContacts.clear();
    if (RegExp(r'^-?[0-9]+$').hasMatch(text)) {
      searchContacts.add(
        KontakModel(nama: 'Kirim ke $text', telp: [text], label: 'Khusus'),
      );
    }

    contacts.forEach((cont) {
      if (cont.nama.toLowerCase().contains(text.toLowerCase()) ||
          cont.telp.where((t) => t.contains(text)).isNotEmpty) {
        searchContacts.add(cont);
      }
    });
  }

  String encodeContact(String number) {
    return contact.containsKey(number) ? contact[number] ?? number : number;
  }

  void listener(SendStatus status) {
    try {
      String body = smsTfController.text;
      DateTime date = DateTime.now();

      // if (status == SendStatus.SENT) {}
      if (status == SendStatus.DELIVERED) {
        smsTfController.clear();
        addNewMessage(
          date: date,
          body: body,
          type: SmsType.MESSAGE_TYPE_SENT,
        );

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
        message: smsTfController.text,
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

  Future groupAndPredictSms() async {
    try {
      // Membuat list berdasarkan key dari semua threadID Sms
      List<int> keys = [];
      _messagesInbox.forEach((msg) {
        keys.add(msg.threadId ?? 0);
      });
      _messagesSent.forEach((msg) {
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
            // Periksa SMS jika dari nomor baru maka akan diprediksi
            PredictModel _predict =
                PredictModel(tipe: 3, tipeDecode: '', confidence: '100');

            if (s.type == SmsType.MESSAGE_TYPE_INBOX &&
                checkIsNumber(
                  sender: s.address.toString(),
                  withLength: true,
                )) {
              _predict = predict(s.body.toString());
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
          sender: sms.first.address.toString(),
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

  void createNewSms(KontakModel kontak) {
    listMessage.add(ListSmsModel(
      threadID: -1,
      sender: kontak.telp.first,
      date: DateTime.now(),
      messages: [],
    ));

    listMessageActive = listMessage.length - 1;
  }

  void addNewMessage({DateTime? date, String? body, SmsType? type}) {
    DateTime _date = date ?? DateTime.now();
    PredictModel _predict = PredictModel(
      tipe: 3,
      tipeDecode: '',
      confidence: '',
    );

    if (type == SmsType.MESSAGE_TYPE_INBOX &&
        checkIsNumber(
          sender: listMessage[listMessageActive].sender,
          withLength: true,
        )) {
      _predict = predict(body.toString());
    }

    listMessage[listMessageActive].date = _date;
    listMessage[listMessageActive].messages.insert(
          0,
          SmsModel(
            body: body.toString(),
            date: _date,
            type: type,
            predict: _predict,
          ),
        );

    listMessage.sort((a, b) => b.date.compareTo(a.date));
  }

  int getIndexListMessage(String sender) {
    try {
      return listMessage
          .indexOf((listMessage.singleWhere((msg) => msg.sender == sender)));
    } catch (e) {
      log(e.toString());
    }

    return -1;
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

  bool checkIsNumber({required String sender, bool withLength = false}) {
    bool cek = sender.contains(new RegExp(r'[0-9]'));
    bool cekLength = true;

    if (withLength) {
      cekLength = sender.length > 6;
    }

    return cek && cekLength;
  }
}
