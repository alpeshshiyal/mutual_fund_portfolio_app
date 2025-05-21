
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final chartProvider = ChangeNotifierProvider((ref){
  return ChartProvider();
});

class ChartProvider extends ChangeNotifier{
  String selectedDuration = 'MAX';

  final Map<String, List<FlSpot>> userData = {
    '1M': [FlSpot(0, 4), FlSpot(1, 4.5)],
    '3M': [FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 4.5)],
    '6M': [FlSpot(0, 2), FlSpot(1, 3), FlSpot(2, 4), FlSpot(3, 5)],
    '1Y': [FlSpot(0, 2.5), FlSpot(1, 3.2), FlSpot(2, 4.1), FlSpot(3, 5)],
    '3Y': [FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 4.2), FlSpot(3, 4.8)],
    'MAX': [FlSpot(0, 3), FlSpot(1, 5), FlSpot(2, 4), FlSpot(3, 7)],
  };

  final Map<String, List<FlSpot>> benchmarkData = {
    '1M': [FlSpot(0, 4.2), FlSpot(1, 4.8)],
    '3M': [FlSpot(0, 3.2), FlSpot(1, 4.5), FlSpot(2, 4.9)],
    '6M': [FlSpot(0, 2.5), FlSpot(1, 3.2), FlSpot(2, 4.1), FlSpot(3, 5.1)],
    '1Y': [FlSpot(0, 3), FlSpot(1, 3.5), FlSpot(2, 4.5), FlSpot(3, 6)],
    '3Y': [FlSpot(0, 3.5), FlSpot(1, 4.5), FlSpot(2, 5.2), FlSpot(3, 6.2)],
    'MAX': [FlSpot(0, 2), FlSpot(1, 6), FlSpot(2, 5), FlSpot(3, 8)],
  };


  //Investment Chart data

  double investmentValue = 1; // in Lakhs
  bool isOneTime = true;
  static int valueIn = 100000;

  toggleIsOneTime(index){
    isOneTime = index == 0;
    notifyListeners();
  }

  onChangeInvestmentValue(value) {
    investmentValue = value;
    notifyListeners();
  }

  // Dummy logic: returns based on selected value
  double getFundReturn() => double.tryParse(((investmentValue*valueIn) * 4.55).toStringAsPrecision(2))??0;
  double getCategoryReturn() => double.tryParse(((investmentValue*valueIn) * 3.63).toStringAsPrecision(2))??0;
  double getSavingReturn() => double.tryParse(((investmentValue*valueIn) * 1.19).toStringAsPrecision(2))??0;

  double getProfitPercentage(){
    var profit = getFundReturn() - (investmentValue*valueIn);
    var revenue= profit/ (investmentValue*valueIn);
    var margin = revenue * 100;
    return margin;
  }
  String formatToLakh(num amount) {
    if (amount >= 100000) {
      double inLakhs = amount / 100000;
      return "${inLakhs.toStringAsFixed(inLakhs.truncateToDouble() == inLakhs ? 0 : 1)} L";
    } else {
      return amount.toString();
    }
  }
}
