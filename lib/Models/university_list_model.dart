// To parse this JSON data, do
//
//     final universityListModel = universityListModelFromJson(jsonString);

import 'dart:convert';

UniversityListModel universityListModelFromJson(String str) =>
    UniversityListModel.fromJson(json.decode(str));

String universityListModelToJson(UniversityListModel data) =>
    json.encode(data.toJson());

class UniversityListModel {
  UniversityListModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory UniversityListModel.fromJson(Map<String, dynamic> json) =>
      UniversityListModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.name,
    this.ranking,
    this.registerLink,
    this.requirementLink,
    this.createAt,
  });

  String? id;
  String? name;
  String? ranking;
  String? registerLink;
  String? requirementLink;
  DateTime? createAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        ranking: json["ranking"],
        registerLink: json["register_link"],
        requirementLink: json["requirement_link"],
        createAt: DateTime.parse(json["create_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ranking": ranking,
        "register_link": registerLink,
        "requirement_link": requirementLink,
        "create_at": createAt,
      };
}
