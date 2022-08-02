class PredictModel {
  late final int tipe;
  late final String tipeDecode;
  late final String confidence;

  PredictModel({
    required this.tipe,
    required this.tipeDecode,
    required this.confidence,
  });

  PredictModel.fromJson(Map<String, dynamic> json) {
    tipe = json['tipe'];
    tipeDecode = json['tipeDecode'];
    confidence = json['confidence'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['tipe'] = tipe;
    _data['tipeDecode'] = tipeDecode;
    _data['confidence'] = confidence;
    return _data;
  }

  bool get isSpam => tipe == 0;
  bool get isHam => tipe == 1;
}
