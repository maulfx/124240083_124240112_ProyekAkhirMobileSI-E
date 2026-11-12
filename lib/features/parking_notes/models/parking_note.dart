class ParkingNote {
  final String locationName;
  final String slotNumber;
  final String note;
  final DateTime createdAt;
  final DateTime? reminderTime;

  ParkingNote({
    required this.locationName,
    required this.slotNumber,
    required this.note,
    required this.createdAt,
    this.reminderTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'locationName': locationName,
      'slotNumber': slotNumber,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'reminderTime': reminderTime?.toIso8601String(),
    };
  }

  factory ParkingNote.fromMap(Map<dynamic, dynamic> map) {
    return ParkingNote(
      locationName: (map['locationName'] as String?) ?? '',
      slotNumber: (map['slotNumber'] as String?) ?? '',
      note: (map['note'] as String?) ?? '',
      createdAt: DateTime.tryParse((map['createdAt'] as String?) ?? '') ?? DateTime.now(),
      reminderTime: map['reminderTime'] != null
          ? DateTime.tryParse(map['reminderTime'] as String)
          : null,
    );
  }
}

