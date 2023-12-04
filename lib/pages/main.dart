import 'package:expense_tracker_app/data/expense_data.dart';
import 'package:expense_tracker_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

//TODO: hive (yerel veri tabanı ekleme işleminden öncesi):
/*
void main() {
  runApp(const MyApp());
}
*/

// TODO: hive (yerel veri tabanı ekleme işlemi):
void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open a hive box -- Box için bir Hive kutusu açın. Bu veritabanı'nın adı olacak.
  await Hive.openBox("expense_database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

/*
return const MaterialApp(
debugShowCheckedModeBanner:false,
home: HomePage(),
)*/
