class ParkingNote {
  final String? id;
  final String? userId;
  final String locationName;
  final String slotNumber;
  final String note;
  final DateTime createdAt;
  final DateTime? reminderTime;
  final bool isSynced;

  ParkingNote({
    this.id,
    this.userId,
    required this.locationName,
    required this.slotNumber,
    required this.note,
    required this.createdAt,
    this.reminderTime,
    this.isSynced = true,
  });

  ParkingNote copyWith({
    String? id,
    String? userId,
    String? locationName,
    String? slotNumber,
    String? note,
    DateTime? createdAt,
    DateTime? reminderTime,
    bool? isSynced,
  }) {
    return ParkingNote(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      locationName: locationName ?? this.locationName,
      slotNumber: slotNumber ?? this.slotNumber,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      reminderTime: reminderTime ?? this.reminderTime,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'locationName': locationName,
      'slotNumber': slotNumber,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'reminderTime': reminderTime?.toIso8601String(),
      'isSynced': isSynced,
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
      isSynced: map['isSynced'] == true ||
          map['is_synced'] == true ||
          (map['isSynced'] == null && map['id'] != null),
    );
  }
}
