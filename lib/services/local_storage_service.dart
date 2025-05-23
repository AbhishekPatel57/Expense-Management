import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class LocalStorageService {
  static const String _expenseKey = 'expenses';

  /// Save a list of expenses to local storage
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = expenses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_expenseKey, jsonList);
  }

  /// Load a list of expenses from local storage
  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_expenseKey) ?? [];
    return jsonList.map((item) => Expense.fromJson(jsonDecode(item))).toList();
  }

  /// Clear all stored expenses
  static Future<void> clearExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_expenseKey);
  }
}
