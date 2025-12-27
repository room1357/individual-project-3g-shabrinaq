import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_manager.dart';
import '../utils/currency_utils.dart';
import '../utils/date_utils.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await ExpenseManager.loadExpenses(); 
    setState(() {
      expenses = ExpenseManager.expenses;
      filteredExpenses = expenses;
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B7AB8),
              Color(0xFF6B5B95),
              Color(0xFF4A4063),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Expense Analytics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    // Tombol Export PDF
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                        tooltip: 'Export PDF',
                        onPressed: () async {
                          await _exportPDF(filteredExpenses);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F3F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Search bar
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF9B87C6).withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: Color(0xFF5D4E7C)),
                            decoration: InputDecoration(
                              hintText: 'Search expenses...',
                              hintStyle: TextStyle(color: Color(0xFF9B8BB4)),
                              prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF7B68AA)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            onChanged: (value) {
                              _filterExpenses();
                            },
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Category filter
                      Container(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          children: ['Semua', 'Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan']
                            .map((category) => Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  category,
                                  style: TextStyle(
                                    color: selectedCategory == category 
                                      ? Colors.white 
                                      : Color(0xFF7B68AA),
                                    fontWeight: selectedCategory == category 
                                      ? FontWeight.w600 
                                      : FontWeight.w500,
                                  ),
                                ),
                                selected: selectedCategory == category,
                                backgroundColor: Colors.white,
                                selectedColor: Color(0xFF7B68AA),
                                checkmarkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: selectedCategory == category 
                                      ? Color(0xFF7B68AA) 
                                      : Color(0xFFE8E0F0),
                                  ),
                                ),
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
                      
                      SizedBox(height: 16),
                      
                      // Statistics summary
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD4C5F9),
                              Color(0xFFB4A5D5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFB4A5D5).withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                            Container(
                              width: 1,
                              height: 40,
                              color: Color(0xFF5D4E7C).withOpacity(0.3),
                            ),
                            _buildStatCard('Items', '${filteredExpenses.length}'),
                            Container(
                              width: 1,
                              height: 40,
                              color: Color(0xFF5D4E7C).withOpacity(0.3),
                            ),
                            _buildStatCard('Average', _calculateAverage(filteredExpenses)),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Expense list
                      Expanded(
                        child: filteredExpenses.isEmpty 
                          ? Center(
                              child: Text(
                                'No expenses found',
                                style: TextStyle(
                                  color: Color(0xFF9B8BB4),
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              itemCount: filteredExpenses.length,
                              itemBuilder: (context, index) {
                                final expense = filteredExpenses[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _getCategoryColor(expense.category).withOpacity(0.15),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(expense.category).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(expense.category),
                                        color: _getCategoryColor(expense.category),
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      expense.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xFF5D4E7C),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '${expense.category} • ${expense.formattedDate}',
                                        style: TextStyle(
                                          color: Color(0xFF9B8BB4),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    trailing: Text(
                                      expense.formattedAmount,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF7B68AA),
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
                ),
              ),
            ],
          ),
        ),
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
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF5D4E7C),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4063),
          ),
        ),
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
        return Color(0xFF9B87C6);
      case 'transportasi':
        return Color(0xFF7B68AA);
      case 'utilitas':
        return Color(0xFFB4A5D5);
      case 'hiburan':
        return Color(0xFF8B7AB8);
      case 'pendidikan':
        return Color(0xFF6B5B95);
      default:
        return Color(0xFF9B8BB4);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.restaurant_rounded;
      case 'transportasi':
        return Icons.directions_car_rounded;
      case 'utilitas':
        return Icons.home_rounded;
      case 'hiburan':
        return Icons.movie_rounded;
      case 'pendidikan':
        return Icons.school_rounded;
      default:
        return Icons.attach_money_rounded;
    }
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          expense.title,
          style: TextStyle(
            color: Color(0xFF5D4E7C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Amount', expense.formattedAmount),
            SizedBox(height: 12),
            _buildDetailRow('Category', expense.category),
            SizedBox(height: 12),
            _buildDetailRow('Date', expense.formattedDate),
            SizedBox(height: 12),
            _buildDetailRow('Description', expense.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF7B68AA),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF9B8BB4),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF5D4E7C),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _exportPDF(List<Expense> data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Laporan Pengeluaran',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Judul', 'Kategori', 'Jumlah', 'Tanggal', 'Deskripsi'],
              data: data
                  .map((e) => [
                        e.title,
                        e.category,
                        formatCurrency(e.amount),
                        formatDate(e.date),
                        e.description
                      ])
                  .toList(),
            ),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data berhasil diexport ke PDF'),
        backgroundColor: Color(0xFF7B68AA),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}