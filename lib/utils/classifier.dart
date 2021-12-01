import 'dart:math';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sms_classification/models/predict_model.dart';

// Import tflite_flutter
import 'package:tflite_flutter/tflite_flutter.dart';

import 'preprocessing.dart';

class Classifier {
  // nama file model & tokenizer
  final _modelFile = 'model.tflite';
  final _tokenFile = 'tokenizer.json';

  // Jumlah maksimal kata
  final int _sentenceLen = 50;

  final Preprocessing _preprocessing = Preprocessing();

  late Map<String, int> _tokenizer;

  // TensorFlow Lite Interpreter object
  late Interpreter _interpreter;

  final Map<int, String> tipeDecode = {
    0: 'Penipuan',
    1: 'Judi Online',
    2: 'Pinjaman Online',
    3: 'Lain-lain',
  };

  Future loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    _interpreter = await Interpreter.fromAsset('$_modelFile');
    print('Interpreter loaded successfully');
  }

  Future loadTokenizer() async {
    final tokenJson = await rootBundle
        .loadString('assets/model/$_tokenFile')
        .then((str) => jsonDecode(str));

    _tokenizer = new Map<String, int>.from(tokenJson);
    print('Tokenizer loaded successfully');
  }

  List<double> classify(String rawText) {
    // preprocessing
    String preText = _preprocessing.removeUrl(rawText);
    preText = _preprocessing.removePunc(preText);
    preText = _preprocessing.caseFolding(preText);

    // tokenizeInputText returns List<List<double>>
    // of shape [1, 50].
    List<List<double>> input = tokenizeInputText(preText);

    // output of shape
    var output = List<double>.filled(4, 0).reshape([1, 4]);

    // The run method will run inference and
    // store the resulting values in output.
    _interpreter.run(input, output);

    return output[0];
  }

  List<List<double>> tokenizeInputText(String text) {
    // Whitespace tokenization
    final toks = text.split(' ');

    // Create a list of length==_sentenceLen filled with the value <pad>
    var vec = List<double>.filled(_sentenceLen, 0.0);

    var index = 0;

    // For each word in sentence find corresponding index in dict
    for (var tok in toks) {
      if (index > _sentenceLen) {
        break;
      }
      vec[index++] =
          _tokenizer.containsKey(tok) ? _tokenizer[tok]!.toDouble() : 0.0;
    }

    // returning List<List<double>> as our interpreter input tensor expects the shape, [1,50]
    return [vec];
  }

  PredictModel predict(String rawText) {
    List<double> output = classify(rawText);

    double maxVal = output.reduce(max);
    int idx = output.indexOf(maxVal);

    double confidence = maxVal * 100;

    return PredictModel(
      tipe: idx,
      tipeDecode: tipeDecode[idx].toString(),
      confidence: confidence.toStringAsFixed(2),
    );
  }
}
