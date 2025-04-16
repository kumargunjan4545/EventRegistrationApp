class FormModel {
  final String fullName;
  final String email;
  final String eventType;
  final String gender;

  FormModel({
    required this.fullName,
    required this.email,
    required this.eventType,
    required this.gender,
  });

  // Convert model to Map
  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "email": email,
      "eventType": eventType,
      "gender": gender,
    };
  }

  //  model from Map 
  factory FormModel.fromMap(Map<String, dynamic> map) {
    return FormModel(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      eventType: map['eventType'] ?? '',
      gender: map['gender'] ?? '',
    );
  }

  FormModel copyWith({
    String? fullName,
    String? email,
    String? eventType,
    String? gender,
  }) {
    return FormModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      eventType: eventType ?? this.eventType,
      gender: gender ?? this.gender,
    );
  }

  @override
  String toString() {
    return 'FormModel(fullName: $fullName, email: $email, eventType: $eventType, gender: $gender)';
  }
}