import '../models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum PeriodType { week, month, year, all }

class ExpenseManager {
  static List<Expense> expenses = [
    Expense(
        id:'1',
        title: 'Belanja Bulanan',
        amount: 150000,
        category: 'Makanan',
        date: DateTime(2024, 9, 15),
        description: 'Belanja kebutuhan bulanan di supermarket',
      ),
      Expense(
        id: '2',
        title: 'Bensin Motor',
        amount: 50000,
        category: 'Transportasi',
        date: DateTime(2024, 9, 14),
        description: 'Isi bensin motor untuk transportasi',
      ),
      Expense(
        id: '3',
        title: 'Kopi di Cafe',
        amount: 25000,
        category: 'Makanan',
        date: DateTime(2024, 9, 14),
        description: 'Ngopi pagi dengan teman',
      ),
      Expense(
        id: '4',
        title: 'Tagihan Internet',
        amount: 300000,
        category: 'Utilitas',
        date: DateTime(2024, 9, 13),
        description: 'Tagihan internet bulanan',
      ),
      Expense(
        id: '5',
        title: 'Tiket Bioskop',
        amount: 100000,
        category: 'Hiburan',
        date: DateTime(2024, 9, 12),
        description: 'Nonton film weekend bersama keluarga',
      ),
      Expense(
        id: '6',
        title: 'Beli Buku',
        amount: 75000,
        category: 'Pendidikan',
        date: DateTime(2024, 9, 11),
        description: 'Buku pemrograman untuk belajar',
      ),
      Expense(
        id: '7',
        title: 'Makan Siang',
        amount: 35000,
        category: 'Makanan',
        date: DateTime(2024, 9, 11),
        description: 'Makan siang di restoran',
      ),
      Expense(
        id: '8',
        title: 'Ongkos Bus',
        amount: 10000,
        category: 'Transportasi',
        date: DateTime(2024, 9, 10),
        description: 'Ongkos perjalanan harian ke kampus',
      ),
  ];

  static const String _storageKey = 'saved_expenses';

  // Untuk menyimpan ke SharedPreferences
  static Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = expenses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, data);
  }

  // Untuk memuat data dari SharedPreferences
  static Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_storageKey);
    if (data != null && data.isNotEmpty) {
      expenses = data.map((e) => Expense.fromJson(jsonDecode(e))).toList();
    } 
  }

  // CRUD Operations
  static void addExpense(Expense expense) async {
    expenses.add(expense);
    await _saveExpenses();
  }

  static void updateExpense(Expense updatedExpense) async {
    final index = expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      expenses[index] = updatedExpense;
      await _saveExpenses();
    }
  }

  // Modify saya
  // CRUD Delete Data
  static Future<void> deleteExpense(String id) async {
    expenses.removeWhere((e) => e.id == id);
    await _saveExpenses();
  }

  // Tambahan untuk Statistik
  static Map<String, double> getCategoryTotals() {
    final Map<String, double> totals = {};
    for (var expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  // 1. Mendapatkan total pengeluaran per kategori
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category] = (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  // 2. Mendapatkan pengeluaran tertinggi
  static Expense? getHighestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  // 3. Mendapatkan pengeluaran bulan tertentu
  static List<Expense> getExpensesByMonth(List<Expense> expenses, int month, int year) {
    return expenses.where((expense) => 
      expense.date.month == month && expense.date.year == year
    ).toList();
  }

  // 4. Mencari pengeluaran berdasarkan kata kunci
  static List<Expense> searchExpenses(List<Expense> expenses, String keyword) {
    String lowerKeyword = keyword.toLowerCase();
    return expenses.where((expense) =>
      expense.title.toLowerCase().contains(lowerKeyword) ||
      expense.description.toLowerCase().contains(lowerKeyword) ||
      expense.category.toLowerCase().contains(lowerKeyword)
    ).toList();
  }

  // 5. Mendapatkan rata-rata pengeluaran harian
  static double getAverageDaily(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    
    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);
    
    // Hitung jumlah hari unik
    Set<String> uniqueDays = expenses.map((expense) => 
      '${expense.date.year}-${expense.date.month}-${expense.date.day}'
    ).toSet();
    
    return total / uniqueDays.length;
  }

  // Additional helper methods
  static double getTotalExpenses() {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
  
  static List<Expense> getRecentExpenses({int limit = 5}) {
    var sorted = List<Expense>.from(expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }
  
  // filter berdasarkan period (Week, Month, Year)
  static Map<String, double> getCategoryTotalsByPeriod({
    required PeriodType period,
    int? year,
    int? month,
    int? week,
  }) {
    Map<String, double> totals = {};
    
    for (var expense in expenses) {
      bool isInPeriod = false;
      
      switch (period) {
        case PeriodType.year:
          // Filter berdasarkan tahun
          isInPeriod = expense.date.year == year;
          break;
          
        case PeriodType.month:
          // Filter berdasarkan bulan dan tahun
          isInPeriod = expense.date.year == year && 
                       expense.date.month == month;
          break;
          
        case PeriodType.week:
          // Filter berdasarkan minggu dalam tahun
          if (expense.date.year == year) {
            int expenseWeek = _getWeekOfYear(expense.date);
            isInPeriod = expenseWeek == week;
          }
          break;
          
        case PeriodType.all:
          isInPeriod = true;
          break;
      }
      
      // totals
      if (isInPeriod) {
        String category = expense.category;
        totals[category] = (totals[category] ?? 0) + expense.amount;
      }
    }
    
    return totals;
  }
  
  // untuk mendapatkan minggu ke berapa dalam tahun
  static int _getWeekOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final daysSinceStart = date.difference(startOfYear).inDays;
    
    // Menghitung week
    return (daysSinceStart / 7).floor() + 1;
  }
}