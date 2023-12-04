import 'package:expense_tracker_app/components/expense_summary.dart';
import 'package:expense_tracker_app/components/expense_tile.dart';
import 'package:expense_tracker_app/data/expense_data.dart';
import 'package:expense_tracker_app/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers kullanıcının yazdıklarını denetleyen alan
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  // Hive db (Başlangıçta uygulama başlatıldığında verilerin hazırlandığından emin olalım.)
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // prepare data on startup.
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add new expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),

            Row(
              // bir row alanına TextField tanımlarsak isek genişlik vermemiz gerekir. Onun için Expanded ettim.
              children: <Widget>[
                // dollars
                Expanded(
                  child: TextField(
                    controller: newExpenseDollarController,
                    keyboardType: TextInputType.number,
                    // sadece sayılar girilebilir alanı oluşturdu.
                    decoration: const InputDecoration(
                      // ipuçları için oluşturulmuştur.
                      hintText: "Dollars",
                    ),
                  ),
                ),
                // cents
                Expanded(
                  child: TextField(
                    controller: newExpenseCentsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Cents",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // save
  void save() {
    // only sace expense if all fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty) {
      // put dollars and cents together
      String amount =
          "${newExpenseDollarController.text}.${newExpenseCentsController.text}";

      // gider verilerine kaydedilmesini istiyoruz bunun için de durum yönetiminden (provider) kullanıcam.
      // create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context); // showDialog close
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      // gider verilerimize erişim sağlamak için Scaffold'u Consumer ile sarmalarız.

      builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text("Expense Tracker",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1,
                )),
          ),
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.green,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: ListView(
            children: <Widget>[
              // weekly summary

              const SizedBox(height: 5),

              ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              const SizedBox(height: 30),

              // expense list
              ListView.builder(
                shrinkWrap: true,
                // liste içinde liste oluşturabilmek için kullanıldı.
                physics: const NeverScrollableScrollPhysics(),
                // kaydırılabilir olmasın.
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) =>
                      deleteExpense(value.getAllExpenseList()[index]),
                ),
              ),
            ],
          )),
    );
  }
}

// TODO: expense_tile.dart pre-code (öncesi kodum):

/*
itemBuilder: (context, index) => ListTile(
title: Text(value.getAllExpenseList()[index].name),
subtitle: Text(value.getAllExpenseList()[index].dateTime.toString()),
trailing: Text('\$' + value.getAllExpenseList()[index].amount),
),
),*/
