// To parse this JSON data, do
//
//     final universityListModel = universityListModelFromJson(jsonString);

import 'dart:convert';

UniversityListModel universityListModelFromJson(String str) => UniversityListModel.fromJson(json.decode(str));

String universityListModelToJson(UniversityListModel data) => json.encode(data.toJson());

class UniversityListModel {
    UniversityListModel({
        this.status,
        this.message,
        this.result,
    });

    int? status;
    String? message;
    List<Result>? result;

    factory UniversityListModel.fromJson(Map<String, dynamic> json) => UniversityListModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
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
        this.meritResult,
    });

    String? id;
    String? name;
    String? ranking;
    String? registerLink;
    String? requirementLink;
    List<MeritResult>? meritResult;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        ranking: json["ranking"],
        registerLink: json["register_link"],
        requirementLink: json["requirement_link"],
        meritResult: List<MeritResult>.from(json["merit_result"].map((x) => MeritResult.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ranking": ranking,
        "register_link": registerLink,
        "requirement_link": requirementLink,
        "merit_result": List<dynamic>.from(meritResult!.map((x) => x.toJson())),
    };
}

class MeritResult {
    MeritResult({
        this.id,
        this.universityId,
        this.deptName,
        this.lastMerit,
        this.lastMeritUrl,
        this.entryTest,
    });

    String? id;
    String? universityId;
    String? deptName;
    String? lastMerit;
    String? lastMeritUrl;
    String? entryTest;

    factory MeritResult.fromJson(Map<String, dynamic> json) => MeritResult(
        id: json["id"],
        universityId: json["university_id"],
        deptName: json["dept_name"],
        lastMerit: json["last_merit"],
        lastMeritUrl: json["last_merit_url"],
        entryTest: json["entry_test"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "university_id": universityId,
        "dept_name": deptName,
        "last_merit": lastMerit,
        "last_merit_url": lastMeritUrl,
        "entry_test": entryTest,
    };
}
