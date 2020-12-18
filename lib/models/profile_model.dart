import 'package:connector/models/user_model.dart';
import 'package:connector/models/date_model.dart';

class ProfileModel {
  String id;
  String title;
  String email;
  String fullName;
  String phone;
  String about;
  double payment;
  String address;
  DateTime createdAt;

  ProfileModel({
    this.id,
    this.title,
    this.email,
    this.fullName,
    this.phone,
    this.about,
    this.payment,
    this.address,
    this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"],
      email: json["email"],
      fullName: json["fullName"],
      phone: json["phone"],
      title: json["title"],
      about: json["about"],
      address: json["address"],
      payment: json["payment"],
      createdAt: Date.fromJson(json["created_at"]),
    );
  }

  factory ProfileModel.fromDocumentSnapshot(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"],
      email: json["email"],
      fullName: json["fullName"],
      phone: json["phone"],
      title: json["title"],
      about: json["about"],
      address: json["address"],
      payment: json["payment"],
      createdAt: Date.fromDocumentSnapshot(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "email": email,
      "fullName": fullName,
      "phone": phone,
      "about": about,
      "address": address,
      "payment": payment,
      "created_at": Date.toJson(createdAt),
    };
  }

  Map<String, dynamic> toPostJson() {
    return {
      "id": id,
      "email": email,
      "fullName": fullName,
      "phone": phone,
      "title": title,
      "about": about,
      "address": address,
      "payment": payment,
      "created_at": Date.toPostJson(createdAt),
    };
  }
}
