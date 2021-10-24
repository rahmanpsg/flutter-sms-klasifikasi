import 'package:telephony/telephony.dart';

import 'predict_model.dart';

class SmsModel {
  // late final int threadID;
  // late final String sender;
  late final String body;
  late final DateTime date;
  late final SmsType? type;
  late final PredictModel predict;

  SmsModel({
    // required this.threadID,
    // required this.sender,
    required this.body,
    required this.date,
    required this.type,
    required this.predict,
  });

  SmsModel.fromJson(Map<String, dynamic> json) {
    // threadID = json['threadID'];
    // sender = json['sender'];
    body = json['body'];
    date = json['date'];
    type = json['type'];
    predict = PredictModel.fromJson(json['predict']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    // _data['threadID'] = threadID;
    // _data['sender'] = sender;
    _data['body'] = body;
    _data['date'] = date;
    _data['type'] = type;
    _data['predict'] = predict.toJson();
    return _data;
  }
}
