import 'sms_model.dart';

class ListSmsModel {
  ListSmsModel({
    required this.threadID,
    required this.sender,
    required this.date,
    required this.messages,
  });
  late final int threadID;
  late final String sender;
  late DateTime date;
  late final List<SmsModel> messages;

  ListSmsModel.fromJson(Map<String, dynamic> json) {
    threadID = json['threadID'];
    sender = json['sender'];
    date = json['date'];
    messages =
        List.from(json['messages']).map((e) => SmsModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['threadID'] = threadID;
    _data['sender'] = sender;
    _data['date'] = date;
    _data['messages'] = messages;
    return _data;
  }
}
