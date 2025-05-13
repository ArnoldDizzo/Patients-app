class VitalRecord {
  final String bloodPressure;
  final String pulse;
  final String sugar;
  final String weight;
  final String cholesterol;
  final DateTime timestamp;

  VitalRecord({
    required this.bloodPressure,
    required this.pulse,
    required this.sugar,
    required this.weight,
    required this.cholesterol,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'blood_pressure': bloodPressure,
      'pulse': pulse,
      'sugar': sugar,
      'weight': weight,
      'cholesterol': cholesterol,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory VitalRecord.fromMap(Map<String, dynamic> map) {
    return VitalRecord(
      bloodPressure: map['blood_pressure'] as String,
      pulse: map['pulse'] as String,
      sugar: map['sugar'] as String,
      weight: map['weight'] as String,
      cholesterol: map['cholesterol'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
} 