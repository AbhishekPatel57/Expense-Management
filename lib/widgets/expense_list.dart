import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseList({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return expenses.isEmpty
        ? Center(child: Text('No expenses added yet!'))
        : ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (ctx, index) {
              final exp = expenses[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  title: Text(exp.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat.yMMMd().format(exp.date)),
                  trailing: Text('\$${exp.amount.toStringAsFixed(2)}'),
                ),
              );
            },
          );
  }
}
