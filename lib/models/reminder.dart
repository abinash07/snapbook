class Reminder {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String freeTime;
  final DateTime callTime;

  Reminder({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.freeTime,
    required this.callTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'freeTime': freeTime,
      'callTime': callTime.toIso8601String(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      freeTime: map['freeTime'],
      callTime: DateTime.parse(map['callTime']),
    );
  }
}
