/// User model
class User {
  final String id;
  final String? email;
  final String? name;
  final int? age;
  final String? gender;
  final DateTime? createdAt;
  final DateTime? lastTestDate;

  User({
    required this.id,
    this.email,
    this.name,
    this.age,
    this.gender,
    this.createdAt,
    this.lastTestDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : null,
      lastTestDate: json['lastTestDate'] != null 
          ? DateTime.parse(json['lastTestDate'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'gender': gender,
      'createdAt': createdAt?.toIso8601String(),
      'lastTestDate': lastTestDate?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    int? age,
    String? gender,
    DateTime? createdAt,
    DateTime? lastTestDate,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      lastTestDate: lastTestDate ?? this.lastTestDate,
    );
  }
}
