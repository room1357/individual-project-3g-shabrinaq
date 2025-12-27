import 'package:flutter/material.dart';
import '../models/shared_expense.dart';

class AddSharedExpenseScreen extends StatefulWidget {
  final String currentUsername;
  final Function(SharedExpense) onSave;

  const AddSharedExpenseScreen({
    super.key,
    required this.currentUsername,
    required this.onSave,
  });

  @override
  State<AddSharedExpenseScreen> createState() => _AddSharedExpenseScreenState();
}

class _AddSharedExpenseScreenState extends State<AddSharedExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _participantController = TextEditingController();
  
  List<String> participants = [];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _participantController.dispose();
    super.dispose();
  }

  void _addParticipant() {
    if (_participantController.text.trim().isNotEmpty) {
      final username = _participantController.text.trim();
      if (!participants.contains(username) && username != widget.currentUsername) {
        setState(() {
          participants.add(username);
          _participantController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Participant already added or same as you'),
            backgroundColor: Color(0xFF7B68AA),
          ),
        );
      }
    }
  }

  void _removeParticipant(int index) {
    setState(() {
      participants.removeAt(index);
    });
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      if (participants.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please add at least one participant'),
            backgroundColor: Color(0xFF7B68AA),
          ),
        );
        return;
      }

      final totalAmount = double.parse(_amountController.text);
      final allParticipants = [widget.currentUsername, ...participants];
      final amountPerPerson = totalAmount / allParticipants.length;

      final participantsList = allParticipants.map((username) {
        return Participant(
          username: username,
          amount: amountPerPerson,
          isPaid: username == widget.currentUsername,
        );
      }).toList();

      final expense = SharedExpense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        totalAmount: totalAmount,
        createdBy: widget.currentUsername,
        createdAt: DateTime.now(),
        participants: participantsList,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      widget.onSave(expense);
      Navigator.pop(context);
    }
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
                        'Add Shared Expense',
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
                    color: Color(0xFFF5F3F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),

                          // Title Field
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Expense Title',
                              hintText: 'e.g., Dinner at Restaurant',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFE0D7EE)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFE0D7EE)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF7B68AA), width: 2),
                              ),
                              prefixIcon: Icon(Icons.title_rounded, color: Color(0xFF7B68AA)),
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
                          
                          // Amount Field
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              labelText: 'Total Amount',
                              hintText: '0',
                              prefixText: 'Rp ',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFE0D7EE)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFE0D7EE)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF7B68AA), width: 2),
                              ),
                              prefixIcon: Icon(Icons.payments_rounded, color: Color(0xFF7B68AA)),
                              labelStyle: TextStyle(color: Color(0xFF7B68AA)),
                            ),
                            keyboardType: TextInputType.number,
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
                          
                          // Description Field
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description (Optional)',
                              hintText: 'Add notes...',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFE0D7EE)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFE0D7EE)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF7B68AA), width: 2),
                              ),
                              prefixIcon: Icon(Icons.notes_rounded, color: Color(0xFF7B68AA)),
                              labelStyle: TextStyle(color: Color(0xFF7B68AA)),
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: 24),
                          
                          // Split With Section
                          Text(
                            'Split With',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4E7C),
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          // Add Participant
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _participantController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    hintText: 'Enter username',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFFE0D7EE)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFFE0D7EE)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFF7B68AA), width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.person_add_rounded, color: Color(0xFF7B68AA)),
                                    labelStyle: TextStyle(color: Color(0xFF7B68AA)),
                                  ),
                                  onSubmitted: (_) => _addParticipant(),
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addParticipant,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF7B68AA),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Icon(Icons.add_rounded),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          
                          // Participants List
                          if (participants.isNotEmpty || widget.currentUsername.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.all(16),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Participants (${participants.length + 1})',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF5D4E7C),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  
                                  // Current User
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFF7B68AA),
                                      child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
                                    ),
                                    title: Text(
                                      widget.currentUsername,
                                      style: TextStyle(
                                        color: Color(0xFF5D4E7C),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'You (Paid)',
                                      style: TextStyle(color: Color(0xFF9B8BB4)),
                                    ),
                                    trailing: Icon(Icons.check_circle_rounded, color: Color(0xFF2D7A3E)),
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  
                                  // Other Participants
                                  ...participants.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final participant = entry.value;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xFFF8F6FA),
                                        child: Text(
                                          participant[0].toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF7B68AA),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        participant,
                                        style: TextStyle(
                                          color: Color(0xFF5D4E7C),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.remove_circle_rounded, color: Colors.red[400]),
                                        onPressed: () => _removeParticipant(index),
                                      ),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                          
                          SizedBox(height: 32),
                          
                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveExpense,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7B68AA),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                'Create Shared Expense',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 20),
                        ],
                      ),
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