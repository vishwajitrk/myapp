import 'dart:convert';

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

class User {
    int id;
    String? email;
    String? firstName;
    String? lastName;
    String? avatar;

    User({
        required this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.avatar,
    });

    factory User.fromJSON(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
    };
}
