import 'date_model.dart';

class UserModel {
  String uid;
  String email;
  String username;
  String phone;
  String firstName;
  String lastName;
  String profilePicture;
  DateTime joinedAt;
  DateTime modifiedAt;
  String password;
  bool isProviderAuth;
  bool isCompany;

  UserModel({
    this.uid,
    this.email,
    this.username,
    this.phone,
    this.firstName,
    this.lastName,
    this.joinedAt,
    this.modifiedAt,
    this.profilePicture,
    this.password,
    this.isProviderAuth,
    this.isCompany,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return new UserModel(
      uid: json["uid"],
      email: json["email"],
      username: json["username"],
      phone: json["phone"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      profilePicture: json["profile_picture"],
      joinedAt:
          json["joined_at"] != null ? Date.fromJson(json["joined_at"]) : null,
      modifiedAt: json["modified_at"] != null
          ? Date.fromJson(json["modified_at"])
          : null,
      isCompany: json["isCompany"],
    );
  }

  factory UserModel.fromDocumentSnapshot(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      email: json["email"],
      username: json["username"],
      phone: json["phone"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      profilePicture: json["profile_picture"],
      joinedAt: json["joined_at"] != null
          ? Date.fromDocumentSnapshot(json["joined_at"])
          : null,
      modifiedAt: json["modified_at"] != null
          ? Date.fromDocumentSnapshot(json["modified_at"])
          : null,
      isCompany: json["isCompany"],
    );
  }

  factory UserModel.fromTransaction(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      email: json["email"],
      username: json["username"],
      phone: json["phone"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      profilePicture: json["profile_picture"],
      joinedAt: json["joined_at"] ?? null,
      modifiedAt: json["modified_at"] ?? null,
      isCompany: json["isCompany"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "joined_at": Date.toJson(joinedAt),
        "modified_at": Date.toJson(modifiedAt),
        "phone": phone,
        "profile_picture": profilePicture,
        "username": username,
        "isCompany": isCompany,
      };

  Map<String, dynamic> toPostJson() => {
        "uid": uid,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "joined_at": Date.toPostJson(joinedAt),
        "modified_at": Date.toPostJson(modifiedAt),
        "phone": phone,
        "profile_picture": profilePicture,
        "username": username,
        "isCompany": isCompany,
      };
}
