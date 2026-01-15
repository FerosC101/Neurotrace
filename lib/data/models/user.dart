import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User model
@JsonSerializable()
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

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
