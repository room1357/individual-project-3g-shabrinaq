class SharedExpense {
  final String id;
  final String title;
  final double totalAmount;
  final String createdBy;
  final DateTime createdAt;
  final List<Participant> participants;
  final String? description;
  final String? category;
  
  SharedExpense({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.createdBy,
    required this.createdAt,
    required this.participants,
    this.description,
    this.category,
  });

  // digunakan baris "exp.isFullyPaid" agar tidak error (class screen)
  bool get isFullyPaid => participants.every((p) => p.isPaid);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalAmount': totalAmount,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'description': description,
      'category': category,
    };
  }

  factory SharedExpense.fromJson(Map<String, dynamic> json) {
    return SharedExpense(
      id: json['id'],
      title: json['title'],
      totalAmount: json['totalAmount'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      participants: (json['participants'] as List)
          .map((p) => Participant.fromJson(p))
          .toList(),
      description: json['description'],
      category: json['category'],
    );
  }
}

class Participant {
  final String username;
  final double amount;
  final bool isPaid;
  
  Participant({
    required this.username,
    required this.amount,
    this.isPaid = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'amount': amount,
      'isPaid': isPaid,
    };
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      username: json['username'],
      amount: json['amount'],
      isPaid: json['isPaid'] ?? false,
    );
  }

  Participant copyWith({bool? isPaid}) {
    return Participant(
      username: username,
      amount: amount,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}