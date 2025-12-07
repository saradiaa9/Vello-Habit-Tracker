class UserModel {
  String id;
  String name;
  String username;
  String email;
  String phoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
    print(user);
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
