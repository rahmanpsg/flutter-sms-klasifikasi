import 'package:intl/intl.dart';

class Waktu {
  final DateTime dateTime;

  static const List<String> _hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];
  static const List<String> _bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  static const List<String> _kuartal = [
    'pertama',
    'kedua',
    'ketiga',
    'keempat'
  ];

  Waktu(this.dateTime);

  String E() => _hari[this.dateTime.weekday - 1].substring(0, 3);
  String EEEE() => _hari[this.dateTime.weekday - 1];
  String LLL() => _bulan[this.dateTime.month - 1].substring(0, 3);
  String LLLL() => _bulan[this.dateTime.month - 1];
  String MMM() => _bulan[this.dateTime.month - 1].substring(0, 3);
  String MMMd() =>
      '${this.dateTime.day.toString()} ${_bulan[this.dateTime.month - 1].substring(0, 3)}';
  String MMMEd() =>
      '${_hari[this.dateTime.weekday - 1].substring(0, 3)}, ${this.dateTime.day.toString()} ${_bulan[this.dateTime.month - 1].substring(0, 3)}';
  String MMMM() => _bulan[this.dateTime.month - 1];
  String MMMMd() =>
      '${this.dateTime.day.toString()} ${_bulan[this.dateTime.month - 1]}';
  String MMMMEEEEd() =>
      '${_hari[this.dateTime.weekday - 1]}, ${this.dateTime.day.toString()} ${_bulan[this.dateTime.month - 1]}';
  String QQQQ() =>
      'Kuartal ${_kuartal[((this.dateTime.month - 1) / 3).floor()]}';
  String yMd() =>
      '${this.dateTime.day.toString()}/${this.dateTime.month.toString()}/${this.dateTime.year.toString()}';
  String yMEd() =>
      '${_hari[this.dateTime.weekday - 1].substring(0, 3)}, ${this.dateTime.day.toString()}/${this.dateTime.month.toString()}/${this.dateTime.year.toString()}';
  String yMMM() =>
      '${_bulan[this.dateTime.month - 1].substring(0, 3)} ${this.dateTime.year.toString()}';
  String yMMMd() =>
      '${this.dateTime.day.toString()} ${_bulan[this.dateTime.month - 1].substring(0, 3)} ${this.dateTime.year.toString()}';
  String yMMMEd() =>
      '${_hari[this.dateTime.weekday - 1].substring(0, 3)}, ${this.dateTime.day.toString()} ${_bulan[this.dateTime.month - 1].substring(0, 3)} ${this.dateTime.year.toString()}';
  String yMMMM() =>
      '${_bulan[this.dateTime.month - 1]} ${this.dateTime.year.toString()}';
  String yMMMMd() =>
      '${this.dateTime.day.toString()} ${_bulan[this.dateTime.month - 1]} ${this.dateTime.year.toString()}';
  String yMMMMEEEEd() =>
      '${_hari[this.dateTime.weekday - 1]}, ${this.dateTime.day.toString()} ${_bulan[this.dateTime.month - 1]} ${this.dateTime.year.toString()}';

  String format(String format) {
    format = format.replaceAll('EEEE', "'${this.EEEE()}'");
    format = format.replaceAll('E', "'${this.E()}'");
    format = format.replaceAll('LLLL', "'${this.LLLL()}'");
    format = format.replaceAll('LLL', "'${this.LLL()}'");
    format = format.replaceAll('MMMM', "'${this.MMMM()}'");
    format = format.replaceAll('MMM', "'${this.MMM()}'");

    return DateFormat(format).format(this.dateTime);
  }
}
