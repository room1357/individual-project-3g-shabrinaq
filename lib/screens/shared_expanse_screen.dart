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
                      icon: Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Shared Expenses',
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

              // Summary Cards (tetap di gradient)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'You Owe',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Rp ${_calculateOwedByMe().toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Owed to You',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Rp ${_calculateOwedToMe().toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

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
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF7B68AA),
                          ),
                        )
                      : expenses.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.receipt_long_rounded,
                                      size: 80,
                                      color: Color(0xFF9B8BB4).withOpacity(0.5)),
                                  SizedBox(height: 16),
                                  Text(
                                    'No shared expenses yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF5D4E7C),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Create one to split bills with friends',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF9B8BB4),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(20),
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                final expense = expenses[index];
                                return _buildExpenseCard(expense);
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewExpense,
        backgroundColor: Color(0xFF7B68AA),
        icon: Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
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
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9B87C6).withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFF8F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.receipt_rounded, color: Color(0xFF7B68AA)),
        ),
        title: Text(
          expense.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4E7C),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Total: Rp ${expense.totalAmount.toStringAsFixed(0)}',
              style: TextStyle(color: Color(0xFF7B68AA)),
            ),
            if (myParticipation.username.isNotEmpty) ...[
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: myParticipation.isPaid
                      ? Color(0xFFD4F4DD)
                      : Color(0xFFFFE4CC),
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
                        ? Color(0xFF2D7A3E)
                        : Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Color(0xFF7B68AA)),
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