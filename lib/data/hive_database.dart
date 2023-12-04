// TODO: Bir Hive vertabanı için her zaman ilk şey ana fonksiyonda açtığımız kutumuza referans vermektir.
// TODO: ve ardından veriler yazılır ve okunur.
import 'package:hive/hive.dart';

import '../models/expense_item.dart';

class HiveDataBase {
  // reference our box
  final _myBox = Hive.box("expense_database2");

// Write data
  void saveData(List<ExpenseItem> allExpense) {
    /*

      Hive can only store * strings * and * dateTime * , and not custom objects like ExpenseItem  etc.(int)
      so lets convert ExpenseItem objects into types that can be stored in our db.


      all Expense =

      [

        ExpenseItem ( name / amount / dateTime ) bu degerleri Hive db göre dönüştürelim.

      ]

      ->

      [

      [name, amount, dateTime]

      ]

     */
    // Bu liste de tüm harcamalar ( Hive db ) göre biçimlendirilmiştir.
    List<List<dynamic>> allExpenseFormatted = <List>[];

    for (var expense in allExpense) {
      // convert each expenseItem into a list of storable types (Strings, dateTime) - depolanabilir türlerin bir listesine dönüştürelim.
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      // bunu da tablomuza ekleyelim.
      allExpenseFormatted.add(expenseFormatted);
    }

    // finally lets store in our database! ve nihayet put' u kullanabiliriz.
    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

// read data
// bu bilgileri bir gider kalemi oluşturmaya dönüştürelim. Böylece onu tekrar uygulamamızda görüntüleyebiliriz.
  List<ExpenseItem> readData() {
    // Data is stored in Hive as a list of strings + dateTime
    // so lets convert our saved data info ExpenseItem objects.

    /*

      SavedData =

      [

      [name, amount, dateTime],
      ..

      ]

      ->

      [

      ExpenseItem ( name / amount / dateTime ),
      ..

      ]

     */

    //verileri şimdi al.
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expense item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      // add expense to overall list of expenses
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
