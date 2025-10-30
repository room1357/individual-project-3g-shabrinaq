import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/shared_expense.dart';
import 'add_shared_expense_screen.dart';
import 'detail_expense_screen.dart';

class SharedExpensesScreen extends StatefulWidget {
  const SharedExpensesScreen({super.key});

  @override
  State<SharedExpensesScreen> createState() => _SharedExpensesScreenState();
}

class _SharedExpensesScreenState extends State<SharedExpensesScreen> {
  List<SharedExpense> expenses = [];
  String currentUsername = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load current user
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      currentUsername = userData['username'] ?? 'Guest';
    }

    // Load shared expenses
    final expensesJson = prefs.getString('shared_expenses');
    if (expensesJson != null) {
      final List<dynamic> expensesList = jsonDecode(expensesJson);
      expenses = expensesList.map((e) => SharedExpense.fromJson(e)).toList();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = jsonEncode(expenses.map((e) => e.toJson()).toList());
    await prefs.setString('shared_expenses', expensesJson);
  }

  void _addNewExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSharedExpenseScreen(
          currentUsername: currentUsername,
          onSave: (expense) {
            setState(() {
              expenses.insert(0, expense);
            });
            _saveExpenses();
          },
        ),
      ),
    );
  }

  void _markAsPaid(SharedExpense expense, String participantUsername) async {
    final updatedParticipants = expense.participants.map((p) {
      if (p.username == participantUsername) {
        return p.copyWith(isPaid: true);
      }
      return p;
    }).toList();

    final updatedExpense = SharedExpense(
      id: expense.id,
      title: expense.title,
      totalAmount: expense.totalAmount,
      createdBy: expense.createdBy,
      createdAt: expense.createdAt,
      participants: updatedParticipants,
      description: expense.description,
    );

    setState(() {
      final index = expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        expenses[index] = updatedExpense;
      }
    });

    await _saveExpenses();
  }
  
  double _calculateOwedByMe() {
    double total = 0;
    for (var expense in expenses) {
      for (var participant in expense.participants) {
        if (participant.username == currentUsername && !participant.isPaid) {
          total += participant.amount;
        }
      }
    }
    return total;
  }

  double _calculateOwedToMe() {
    double total = 0;
    for (var expense in expenses) {
      if (expense.createdBy == currentUsername) {
        for (var participant in expense.participants) {
          if (participant.username != currentUsername && !participant.isPaid) {
            total += participant.amount;
          }
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Shared Expenses'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary Cards
                Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'You Owe',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${_calculateOwedByMe().toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Owed to You',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${_calculateOwedToMe().toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Expenses List
                Expanded(
                  child: expenses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long,
                                  size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No shared expenses yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create one to split bills with friends',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            return _buildExpenseCard(expense);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewExpense,
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Expense',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(SharedExpense expense) {
    final myParticipation = expense.participants.firstWhere(
      (p) => p.username == currentUsername,
      orElse: () => Participant(username: '', amount: 0),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.receipt, color: Colors.blue),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Total: Rp ${expense.totalAmount.toStringAsFixed(0)}'),
            if (myParticipation.username.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: myParticipation.isPaid
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  myParticipation.isPaid
                      ? 'Paid'
                      : 'You owe: Rp ${myParticipation.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: myParticipation.isPaid
                        ? Colors.green[700]
                        : Colors.orange[700],
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseDetailScreen(
                expense: expense,
                currentUsername: currentUsername,
                onMarkPaid: _markAsPaid,
              ),
            ),
          );
        },
      ),
    );
  }
}