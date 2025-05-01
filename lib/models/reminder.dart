class Reminder {
  final String id;
  final String name;
  final String mobile;
  final String location;
  final DateTime dob;
  final String howWeMet;
  final DateTime anniversary;
  final String remark;
  final DateTime callTime;

  Reminder({
    required this.id,
    required this.name,
    required this.mobile,
    required this.location,
    required this.dob,
    required this.howWeMet,
    required this.anniversary,
    required this.remark,
    required this.callTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'location': location,
      'dob': dob.toIso8601String(),
      'howWeMet': howWeMet,
      'anniversary': anniversary.toIso8601String(),
      'callTime': callTime.toIso8601String(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      name: map['name'],
      mobile: map['mobile'],
      location: map['location'],
      dob: DateTime.parse(map['dob']),
      howWeMet: map['howWeMet'],
      anniversary: DateTime.parse(map['anniversary']),
      remark: map['remark'],
      callTime: DateTime.parse(map['callTime']),
    );
  }
}
