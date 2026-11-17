class ParkingNote {
  final String? id;
  final String? userId;
  final String locationName;
  final String slotNumber;
  final String note;
  final DateTime createdAt;
  final DateTime? reminderTime;

  ParkingNote({
    this.id,
    this.userId,
    required this.locationName,
    required this.slotNumber,
    required this.note,
    required this.createdAt,
    this.reminderTime,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'locationName': locationName,
      'slotNumber': slotNumber,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'reminderTime': reminderTime?.toIso8601String(),
    };
  }

  Map<String, dynamic> toSupabaseMap() {
    final map = <String, dynamic>{
      'location_name': locationName,
      'slot_number': slotNumber,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'reminder_time': reminderTime?.toIso8601String(),
    };
    if (id != null && id!.isNotEmpty) {
      map['id'] = id;
    }
    if (userId != null && userId!.isNotEmpty) {
      map['user_id'] = userId;
    }
    return map;
  }

  factory ParkingNote.fromMap(Map<dynamic, dynamic> map) {
    return ParkingNote(
      id: map['id']?.toString(),
      userId: (map['user_id'] ?? map['userId'])?.toString(),
      locationName: ((map['location_name'] ?? map['locationName']) as String?) ?? '',
      slotNumber: ((map['slot_number'] ?? map['slotNumber']) as String?) ?? '',
      note: (map['note'] as String?) ?? '',
      createdAt: DateTime.tryParse(((map['created_at'] ?? map['createdAt']) as String?) ?? '') ?? DateTime.now(),
      reminderTime: (map['reminder_time'] ?? map['reminderTime']) != null
          ? DateTime.tryParse((map['reminder_time'] ?? map['reminderTime']) as String)
          : null,
    );
  }
}
