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
          const SnackBar(content: Text('Participant already added or same as you')),
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
          const SnackBar(content: Text('Please add at least one participant')),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Shared Expense'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Expense Title',
                  hintText: 'e.g., Dinner at Restaurant',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Total Amount',
                  hintText: '0',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
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
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Add notes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Split With',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _participantController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_add),
                      ),
                      onSubmitted: (_) => _addParticipant(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addParticipant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (participants.isNotEmpty || widget.currentUsername.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Participants (${participants.length + 1})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        title: Text(widget.currentUsername),
                        subtitle: const Text('You (Paid)'),
                        trailing: const Icon(Icons.check_circle, color: Colors.green),
                        dense: true,
                      ),
                      ...participants.asMap().entries.map((entry) {
                        final index = entry.key;
                        final participant = entry.value;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              participant[0].toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(participant),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removeParticipant(index),
                          ),
                          dense: true,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Shared Expense',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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