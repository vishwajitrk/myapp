import 'dart:convert';

import 'package:equatable/equatable.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<User>? users;
  Support? support;

  UserModel({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.users,
    this.support,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        users: List<User>.from(json["users"].map((x) => User.fromJSON(x))),
        support: Support.fromJson(json["support"]),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_pages": totalPages,
        "users": List<dynamic>.from(users!.map((x) => x.toJson())),
        "support": support?.toJson(),
      };
}

class Support {
  String? url;
  String? text;

  Support({
    this.url,
    this.text,
  });

  factory Support.fromJson(Map<String, dynamic> json) => Support(
        url: json["url"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "text": text,
      };
}

class User extends Equatable {
  final int id;
  final String email;
  final String name;
  final String? lastName;
  final String? avatar;
  final String gender;
  final String status;
  final bool isEditing;
  final bool isDeleting;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.lastName,
    this.avatar,
    required this.gender,
    required this.status,
    this.isEditing = false,
    this.isDeleting = false,
  });

  User copyWith({
    int? id,
    String? email,
    String? name,
    String? lastName,
    String? gender,
    String? status,
    String? avatar,
    bool? isEditing,
    bool? isDeleting,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      isEditing: isEditing ?? this.isEditing,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  static List<User> fromJsonArray(array) {
    return List<User>.from(array.map((x) => User.fromJSON(x)));
  }

  factory User.fromJSON(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
        gender: json["gender"] ?? '',
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": name,
        "last_name": lastName,
        "avatar": avatar,
      };

  @override
  List<Object> get props => [id, email, name, gender, status, isEditing, isDeleting];

  @override
  String toString() =>
      'Item { id: $id, email: $email, name : $name, gender: $gender, status: $status, isEditing : $isEditing, isDeleting: $isDeleting }';
}
