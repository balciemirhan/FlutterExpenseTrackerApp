import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// kullanıcı arayüzü bileşenleri:
// gider kutucuğu oluşturalım.

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  void Function(BuildContext)? deleteTapped;

  ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // kaydırılabilir pencere
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // delete button
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${dateTime.day} / ${dateTime.month} / ${dateTime.year} ",
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF9F9F9F),
          ),
        ),
        trailing: Text(
          "\$$amount",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
