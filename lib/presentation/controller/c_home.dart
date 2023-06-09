import 'dart:math';

import 'package:get/get.dart';
import 'package:money_record/data/source/source_history.dart';

class CHome extends GetxController {
  final _today = 0.0.obs;
  double get today => _today.value;

  final _todayPercent = ''.obs;
  String get todayPercent => _todayPercent.value;

  final _week = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  List<double> get week => _week.value;

  List<String> get days =>
      ['sen', 'sel', 'rab', 'kam', 'jum', 'sab', 'min']; //menampilkan data hari
  List<String> weekText() {
    //fungsi week untuk generate susunan days
    DateTime today = DateTime.now();
    return [
      //hari sekarang adalah hari di paling akhir maka setiap nambah hari maka akan -1
      days[today.subtract(const Duration(days: 6)).weekday - 1],
      days[today.subtract(const Duration(days: 5)).weekday - 1],
      days[today.subtract(const Duration(days: 4)).weekday - 1],
      days[today.subtract(const Duration(days: 3)).weekday - 1],
      days[today.subtract(const Duration(days: 2)).weekday - 1],
      days[today.subtract(const Duration(days: 1)).weekday - 1],
      days[today.weekday - 1],
    ];
  }

  // final _month = {'income': 0.0, 'outcome': 0.0}.obs;
  // Map get month => _month.value;
  final _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;

  final _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;

  final _percentIncome = '0'.obs;
  String get percentIncome => _percentIncome.value;

  final _monthPercent = ''.obs;
  String get monthPercent => _monthPercent.value;

  final _differentMonth = 0.0.obs;
  double get differentMonth => _differentMonth.value;

  getAnalysis(idUser) async {
    Map data = await SourceHistory.analysis(idUser);

    //Today outcome
    _today.value = data['today'].toDouble();
    double yesterday = data['yesterday'].toDouble();
    double different = (today - yesterday).abs();
    bool isSame = today.isEqual(yesterday);
    bool isPlus = today.isGreaterThan(yesterday);
    double deviderToday = (today + yesterday) == 0 ? 1 : (today + yesterday);
    double percent = (different / deviderToday) * 100;
    _todayPercent.value = isSame
        ? '100% sama dengan kemarin'
        : isPlus
            ? '+${percent.toStringAsFixed(0)}% dibanding kemarin'
            : '-${percent.toStringAsFixed(0)}% dibanding kemarin';

    //weekly
    _week.value = List.castFrom(data['week'].map((e) => e.toDouble()).toList());

    //monthly
    _monthIncome.value = data['month']['income'].toDouble();
    _monthOutcome.value = data['month']['outcome'].toDouble();
    _differentMonth.value = (monthIncome - monthOutcome).abs();
    bool isSameMonth = monthIncome.isEqual(monthOutcome);
    bool isPlusMonth = monthIncome.isGreaterThan(monthOutcome);
    double dividerMonth =
        (monthIncome + monthOutcome) == 0 ? 1 : (monthIncome + monthOutcome);
    double percentMonth = (differentMonth / dividerMonth) * 100;
    _percentIncome.value = percentMonth.toStringAsFixed(1);
    _monthPercent.value = isSameMonth
        ? 'Pemasukan\n100% sama\ndengan pengeluaran'
        : isPlus
            ? 'Pemasukan\nlebih besar $percentIncome%\ndibanding kemarin'
            : 'Pemasukan\nlebih kecil $percentIncome%\ndibanding kemarin';
  }
}
