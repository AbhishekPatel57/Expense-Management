import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _MonthlyTotals extends StatelessWidget {
  final List<Expense> expenses;

  const _MonthlyTotals({Key? key, required this.expenses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Text('No monthly totals available.');
    }

    // Group expenses by month and sum amounts
    final Map<String, double> monthlyTotals = {};
    for (var exp in expenses) {
      final monthKey = '${exp.date.year}-${exp.date.month.toString().padLeft(2, '0')}';
      monthlyTotals[monthKey] = (monthlyTotals[monthKey] ?? 0) + exp.amount;
    }

    final sortedKeys = monthlyTotals.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Descending order

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Monthly Totals', style: Theme.of(context).textTheme.titleMedium),
        ...sortedKeys.map((key) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                '$key: ₹${monthlyTotals[key]!.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            )),
      ],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];
  String _selectedCategory = 'All';
  String _sortBy = 'Date';

  final List<String> _categories = ['All', 'Food', 'Transport', 'Bills', 'Shopping', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final loaded = await Expense.loadExpenses();
    setState(() => _expenses = loaded);
  }

  void _addExpense(Expense expense) async {
    setState(() => _expenses.add(expense));
    await Expense.saveExpenses(_expenses);
  }

  void _deleteExpense(int index) async {
    setState(() => _expenses.removeAt(index));
    await Expense.saveExpenses(_expenses);
  }

  List<Expense> get _filteredSortedExpenses {
    var filtered = _selectedCategory == 'All'
        ? _expenses
        : _expenses.where((e) => e.category == _selectedCategory).toList();

    if (_sortBy == 'Amount') {
      filtered.sort((a, b) => b.amount.compareTo(a.amount));
    } else {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    }

    return filtered;
  }

  void _openAddExpenseScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddExpenseScreen(onSubmit: _addExpense),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 'Date', child: Text('Sort by Date')),
              PopupMenuItem(value: 'Amount', child: Text('Sort by Amount')),
            ],
            icon: Icon(Icons.sort),
          ),
          IconButton(icon: Icon(Icons.add), onPressed: _openAddExpenseScreen),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (val) => setState(() => _selectedCategory = val!),
              items: _categories
            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
            .toList(),
              isExpanded: true,
            ),
          ),
          Expanded(
            child: _filteredSortedExpenses.isEmpty
          ? Center(child: Text('No expenses found.'))
          : ListView.builder(
              itemCount: _filteredSortedExpenses.length,
              itemBuilder: (ctx, index) {
                final exp = _filteredSortedExpenses[index];
                return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(exp.title),
              subtitle: Text(
                '${exp.category} • ${exp.date.toLocal().toString().split(' ')[0]}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('₹${exp.amount.toStringAsFixed(2)}'),
                  IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteExpense(index),
                    ),
                    IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // TODO: Implement edit expense functionality
                    },
                    ),
                ],
              ),
            ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _MonthlyTotals(expenses: _filteredSortedExpenses),
          ),
        ],
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}
