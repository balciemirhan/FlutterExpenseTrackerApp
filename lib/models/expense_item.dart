// gider kalemi oluşturma. (birkaç farklı gideri parametreler kullanarak temsil etme.)

class ExpenseItem {
  final String name; // giderin adı
  final String amount; // giderin tutarı
  final DateTime dateTime; // giderin tarihi

  ExpenseItem({
    required this.name,
    required this.amount,
    required this.dateTime,
  });
}
