import 'package:connector/models/profile_model.dart';
import 'package:connector/models/user_model.dart';
import 'package:connector/models/date_model.dart';

class Job {
  String id;
  String title;
  String description;
  UserModel owner;
  int reviewCount;
  double payment;
  int favoriteCount;
  String address;
  DateTime createdAt;
  List<Map<dynamic, dynamic>> applicants;
  bool isActive;

  Job({
    this.id,
    this.title,
    this.description,
    this.owner,
    this.payment,
    this.reviewCount,
    this.favoriteCount,
    this.address,
    this.createdAt,
    this.applicants,
    this.isActive,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      owner: json["owner_user"] != null
          ? UserModel.fromJson(json["owner_user"].cast<String, dynamic>())
          : null,
      reviewCount: json["review_count"] ?? 0,
      favoriteCount: json["favorite_count"] ?? 0,
      address: json["address"],
      payment: json["payment"],
      createdAt: Date.fromJson(json["created_at"]),
      applicants: json["applicants"],
      // ?.cast<ProfileModel>(),
      isActive: json["is_active"],
    );
  }

  factory Job.fromDocumentSnapshot(Map<String, dynamic> json) {
    return Job(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      owner: UserModel.fromDocumentSnapshot(
          json["owner_user"]?.cast<String, dynamic>()),
      reviewCount: json["review_count"] ?? 0,
      favoriteCount: json["favorite_count"] ?? 0,
      address: json["address"],
      payment: json["payment"],
      createdAt: Date.fromDocumentSnapshot(json["created_at"]),
      applicants: json["applicants"] != null
          ? json["applicants"]
              .cast<Map<String, dynamic>>()
              // .map<ProfileModel>((Map<String, dynamic> t) =>
              //     ProfileModel.fromDocumentSnapshot(t))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "owner_user": owner.toJson(),
      "review_count": reviewCount,
      "favorite_count": favoriteCount,
      "address": address,
      "payment": payment,
      "created_at": Date.toJson(createdAt),
      "applicants": applicants,
      "is_active": isActive,
    };
  }

  Map<String, dynamic> toPostJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "owner_user": owner?.toPostJson(),
      "review_count": reviewCount,
      "favorite_count": favoriteCount,
      "address": address,
      "payment": payment,
      "created_at": Date.toPostJson(createdAt),
      "applicants": applicants,
      "is_active": isActive,
    };
  }
}
