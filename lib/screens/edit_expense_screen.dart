import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/user.dart';
import '../services/expense_manager.dart';
import '../services/auth_service.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  
  const EditExpenseScreen({super.key, required this.expense});

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  
  late String _selectedCategory;
  late DateTime _selectedDate;
  
  List<String> _categories = ['Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan'];
  User? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _descriptionController = TextEditingController(text: widget.expense.description);
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCurrentUser();
    await _loadCategories();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  Future<void> _loadCategories() async {
    if (currentUser == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final key = 'categories_${currentUser!.username}';
    final storedData = prefs.getStringList(key);

    setState(() {
      _categories = storedData ?? [
        'Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan',
      ];
      
      // Pastikan kategori yang dipilih ada dalam list
      // Jika tidak ada (misalnya kategori sudah dihapus), set ke kategori pertama
      if (!_categories.contains(_selectedCategory) && _categories.isNotEmpty) {
        _selectedCategory = _categories[0];
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateExpense() {
    if (_formKey.currentState!.validate()) {
      final updatedExpense = Expense(
        id: widget.expense.id,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        description: _descriptionController.text,
      );

      ExpenseManager.updateExpense(updatedExpense);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense updated successfully!'),
          backgroundColor: Color(0xFF7B68AA),
        ),
      );
      
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark  
              ? [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                ]
              : [
                  Color(0xFF8B7AB8),
                  Color(0xFF6B5B95),
                ],
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
            ? [
                Color(0xFF1a1a2e), // Dark purple
                Color(0xFF16213e),
                Color(0xFF0f3460),
              ]
            : [
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
                      icon: Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Edit Expense',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1e1e2e) : Color(0xFFF5F3F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(20),
                      children: [
                        SizedBox(height: 10),

                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.title, color: Color(0xFF7B68AA)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelStyle: TextStyle(color: Color(0xFF7B68AA)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            prefixText: 'Rp ',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.payments, color: Color(0xFF7B68AA)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelStyle: TextStyle(color: Color(0xFF7B68AA)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter valid number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.category, color: Color(0xFF7B68AA)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelStyle: TextStyle(color: Color(0xFF7B68AA)),
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category, style: TextStyle(color: Color(0xFF5D4E7C))),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        SizedBox(height: 16),

                        InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF7B68AA)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelStyle: TextStyle(color: Color(0xFF7B68AA)),
                            ),
                            child: Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: TextStyle(fontSize: 16, color: Color(0xFF5D4E7C)),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.description, color: Color(0xFF7B68AA)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelStyle: TextStyle(color: Color(0xFF7B68AA)),
                          ),
                        ),
                        SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: _updateExpense,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7B68AA),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Update Expense',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}