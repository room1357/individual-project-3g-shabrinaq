import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_manager.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'Makanan';
  DateTime _selectedDate = DateTime.now();
  
  final List<String> _categories = ['Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan'];

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

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final newExpense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        description: _descriptionController.text,
      );

      ExpenseManager.addExpense(newExpense);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pengeluaran berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, true); // Return true untuk refresh data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
                hintText: 'Masukkan judul pengeluaran',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 16),

            // Amount Field
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                hintText: 'Masukkan jumlah pengeluaran',
                prefixIcon: Icon(Icons.attach_money),
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah tidak boleh kosong';
                }
                if (double.tryParse(value) == null) {
                  return 'Jumlah harus berupa angka';
                }
                if (double.parse(value) <= 0) {
                  return 'Jumlah harus lebih dari 0';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: 16),

            // Date Picker
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Masukkan deskripsi pengeluaran',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _saveExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Simpan Pengeluaran',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}