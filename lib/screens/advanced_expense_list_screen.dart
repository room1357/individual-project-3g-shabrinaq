import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_manager.dart';
import 'add_expense_screen.dart';

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  _AdvancedExpenseListScreenState createState() => _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  List<Expense> expenses = ExpenseManager.expenses;
  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredExpenses = expenses;
  }

    void _refreshExpenses() {
    setState(() {
      filteredExpenses = ExpenseManager.expenses;
      _filterExpenses();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengeluaran Advanced'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterExpenses();
              },
            ),
          ),
          
          // Category filter
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: ['Semua', 'Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan']
                .map((category) => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                        _filterExpenses();
                      });
                    },
                  ),
                )).toList(),
            ),
          ),
          
          // Statistics summary
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard('Rata-rata', _calculateAverage(filteredExpenses)),
              ],
            ),
          ),
          
          // Expense list
          Expanded(
            child: filteredExpenses.isEmpty 
              ? Center(child: Text('Tidak ada pengeluaran ditemukan'))
              : ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getCategoryColor(expense.category),
                          child: Icon(_getCategoryIcon(expense.category), color: Colors.white),
                        ),
                        title: Text(expense.title),
                        subtitle: Text('${expense.category} • ${expense.formattedDate}'),
                        trailing: Text(
                          expense.formattedAmount,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600],
                          ),
                        ),
                        onTap: () => _showExpenseDetails(context, expense),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (result == true) {
            _refreshExpenses();
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  void _filterExpenses() {
    setState(() {
      filteredExpenses = expenses.where((expense) {
        bool matchesSearch = searchController.text.isEmpty || 
          expense.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
          expense.description.toLowerCase().contains(searchController.text.toLowerCase());
        
        bool matchesCategory = selectedCategory == 'Semua' || 
          expense.category == selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _calculateTotal(List<Expense> expenses) {
    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  String _calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 'Rp 0';
    double average = expenses.fold(0.0, (sum, expense) => sum + expense.amount) / expenses.length;
    return 'Rp ${average.toStringAsFixed(0)}';
  }

  Color _getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'makanan':
      return Colors.orange;
    case 'transportasi':
      return Colors.green;
    case 'utilitas':
      return Colors.purple;
    case 'hiburan':
      return Colors.pink;
    case 'pendidikan':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

IconData _getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'makanan':
      return Icons.restaurant;
    case 'transportasi':
      return Icons.directions_car;
    case 'utilitas':
      return Icons.home;
    case 'hiburan':
      return Icons.movie;
    case 'pendidikan':
      return Icons.school;
    default:
      return Icons.attach_money;
  }
}

void _showExpenseDetails(BuildContext context, Expense expense) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(expense.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jumlah: ${expense.formattedAmount}'),
          SizedBox(height: 8),
          Text('Kategori: ${expense.category}'),
          SizedBox(height: 8),
          Text('Tanggal: ${expense.formattedDate}'),
          SizedBox(height: 8),
          Text('Deskripsi: ${expense.description}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Tutup'),
        ),
      ],
    ),
  );
}
}