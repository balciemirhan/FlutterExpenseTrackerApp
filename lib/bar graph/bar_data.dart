import 'package:expense_tracker_app/bar graph/individual_bar.dart';
// bir grup çift, yani her gün için miktar.

class BarData {
  // pazar'dan cumartesi'ye kadar.
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  // çubuk verileri adı verilen ayrı çubukların bir listesi.
  List<IndividualBar> barData = [];

  // initialize bar data
  // verileri liste de başlat.
  void initializeBarData() {
    barData = [
      // sun
      IndividualBar(x: 0, y: sunAmount),
      IndividualBar(x: 1, y: monAmount),
      IndividualBar(x: 2, y: tueAmount),
      IndividualBar(x: 3, y: wedAmount),
      IndividualBar(x: 4, y: thurAmount),
      IndividualBar(x: 5, y: friAmount),
      IndividualBar(x: 6, y: satAmount),
    ];
  }

  // böylece tüm günlerin miktarını elde ettim.
  BarData(
      {required this.sunAmount,
      required this.monAmount,
      required this.tueAmount,
      required this.wedAmount,
      required this.thurAmount,
      required this.friAmount,
      required this.satAmount});
}
