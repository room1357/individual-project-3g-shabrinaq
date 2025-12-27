import 'package:flutter/material.dart';
import '../models/shared_expense.dart';
import 'package:intl/intl.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final SharedExpense expense;
  final String currentUsername;
  final Function(SharedExpense, String) onMarkPaid;

  const ExpenseDetailScreen({
    super.key,
    required this.expense,
    required this.currentUsername,
    required this.onMarkPaid,
  });

  @override
  Widget build(BuildContext context) {
    // FIX: Tambahkan isPaid: false pada default Participant
    final myParticipation = expense.participants.firstWhere(
      (p) => p.username == currentUsername,
      orElse: () => Participant(username: '', amount: 0, isPaid: false),
    );

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
                        'Expense Details',
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

              // Header Info
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Icon(Icons.receipt_long_rounded,
                        size: 60, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      expense.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rp ${expense.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(expense.createdAt),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (expense.description != null) ...[
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4E7C),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              expense.description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF7B68AA),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],

                        Text(
                          'Split Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4E7C),
                          ),
                        ),
                        SizedBox(height: 12),

                        ...expense.participants.map((participant) {
                          final isMe = participant.username == currentUsername;
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isMe
                                    ? Color(0xFF7B68AA)
                                    : Color(0xFFE0D7EE),
                                width: isMe ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF9B87C6).withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: isMe
                                      ? Color(0xFF7B68AA)
                                      : Color(0xFFF8F6FA),
                                  child: isMe
                                      ? Icon(Icons.person_rounded,
                                          color: Colors.white)
                                      : Text(
                                          participant.username[0].toUpperCase(),
                                          style: TextStyle(
                                            color: Color(0xFF7B68AA),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isMe
                                            ? '${participant.username} (You)'
                                            : participant.username,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF5D4E7C),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Rp ${participant.amount.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF9B8BB4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: participant.isPaid
                                        ? Color(0xFFD4F4DD)
                                        : Color(0xFFFFE4CC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    participant.isPaid ? 'Paid' : 'Pending',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: participant.isPaid
                                          ? Color(0xFF2D7A3E)
                                          : Color(0xFFD97706),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        SizedBox(height: 24),

                        if (myParticipation.username.isNotEmpty &&
                            !myParticipation.isPaid)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      'Mark as Paid',
                                      style: TextStyle(
                                        color: Color(0xFF5D4E7C),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      'Confirm that you have paid Rp ${myParticipation.amount.toStringAsFixed(0)} for this expense?',
                                      style: TextStyle(color: Color(0xFF7B68AA)),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Color(0xFF9B8BB4)),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          onMarkPaid(expense, currentUsername);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Payment marked as paid!'),
                                              backgroundColor:
                                                  Color(0xFF2D7A3E),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Confirm',
                                          style: TextStyle(
                                            color: Color(0xFF7B68AA),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.check_circle_rounded),
                              label: Text(
                                'Mark as Paid',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2D7A3E),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                            ),
                          ),
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