import '../models/expense.dart';

class ExpenseService {
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  final List<Expense> _expenses = [];

  List<Expense> getAllExpenses() => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  double getTotalByCategory(String category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, double> getExpensesByCategory() {
    final Map<String, double> data = {};
    for (var e in _expenses) {
      data[e.category] = (data[e.category] ?? 0) + e.amount;
    }
    return data;
  }
}