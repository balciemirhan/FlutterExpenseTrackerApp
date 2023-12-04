// harcamalarımız için verilerle ilgili tüm kısımlar.

// gider verilerini yönetmek ve bu verilerle ilgili bazı işlemleri gerçekleştirmek amacıyla tasarlanmıştır.

/*class ExpenseData {
  // list of All expenses

  // get expense list

  // add new expense

  // delete expense

  // get weekday (mon, tues, etc.) from a dateTime object.

  // get the date for the start of the week (sunday)  harcamaları güzel bir grafikte görüntülemek için sadece mevcut haftayı pazar'dan cumartesi'ye kadar görüntülemek istiyorum bu yüzden burada başlangıç tarihini almak için bir yöntem istiyorum.

*/ /*

convert overall list of expenses into a daily expense summary. ( günlük gider özetin)
bu listede bir sürü gider kalemi olacak ve her giderin bir adı,tarihi ve tutarı olacak.

overallExpenseList =

[

[food, 2023/01/30, $10]
[hat, 2023/01/30, $15 ]
[drinks, 2023/01/31,$1 ],
[food, 2023/02/01, $5 ],
[food, 2023/02/01, $6 ],
[food, 2023/02/03, $7 ],
[food, 2023/02/05, $10 ],
[food, 2023/02/05, $11 ],

]

overallExpenseList -- > DailyExpenseSummary listesine dönüştürüyorum.

DailyExpenseSummary = o gün için toplam tutar olacak. Her gün için bir özet ve harcama miktarı.

[

[ 20230130: $25 1,]
[ 20230131: $1 1, ]
[ 20230201: $11 1, ]
[ 20230203: $7 1, ]
[ 20230205: $21 ,]


]


*/ /*
}*/

import 'package:expense_tracker_app/data/hive_database.dart';
import 'package:expense_tracker_app/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';

import '../models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  // list of All expenses
  List<ExpenseItem> overallExpenseList = <ExpenseItem>[];

  // ExpenseItem adında bir sınıfın örneklerini içeren bir liste olan overallExpenseList listesini döndürerek tüm harcamaların bir listesini elde etmeyi amaçlamaktadır.

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display (Hive db) kullanıcı uygulamayı ilk başlattığında veri var mı? durumunu inceler.
  final db = HiveDataBase(); // veritabanı nesnesi
  void prepareData() {
    // if there exists data, get it. Bunun için'de veritabanı nesnesi almamız gerekiyor.
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    // gider kalemidir. Ne sakladığımızı biliriz.
    overallExpenseList.add(newExpense);

    notifyListeners(); // herhangi bir değişklik için dinleyicilere haber vermemiz gerekir. (save)

    db.saveData(overallExpenseList); // Hive db (Kaydetme yöntemini çağırdık.)
    // Böylece veriler başarıyla depolanır.
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();

    // Hive db (Kaydetme yöntemini çağırdık.) gideri silersek verileri'de kaydedelim.
    db.saveData(overallExpenseList);
    // Böylece veriler başarıyla depolanır.
  }

  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return " ";
    }
  }

  // bunu haftanın başlangıcından Pazar gününe kadar görüntülemek istiyorum.
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();

    // go backwards from today find sunday.
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == "Sun") {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  //her günü temsil eden güzel bir toplam elde etmek için bunu bir araya getirmek istiyorum.
  // harita kullanarak temsil edeceğim.

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay  };
    };
    for (var expense in overallExpenseList) {
      // her harcamanın üzerinden geçelim.
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      // check sistemi: günlük gider özetinin doğru olup olomadığını anlamak için yapılır.

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary; // günlük gider özetimizi döndürdük.
  }
}
