import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

ReportListModel reportListModelFromJson(String str) =>
    ReportListModel.fromJson(json.decode(str));

String reportListModelToJson(ReportListModel data) =>
    json.encode(data.toJson());

class ReportListModel {
  String? message;
  ReportListData? data;
  int? status;
  bool? isSuccess;

  ReportListModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory ReportListModel.fromJson(Map<String, dynamic> json) =>
      ReportListModel(
        message: json["Message"],
        data:
            json["Data"] == null ? null : ReportListData.fromJson(json["Data"]),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data?.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class ReportListData {
  List<ReportListDoc>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  ReportListData({
    this.docs,
    this.totalDocs,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory ReportListData.fromJson(Map<String, dynamic> json) => ReportListData(
        docs: json["docs"] == null
            ? []
            : List<ReportListDoc>.from(
                json["docs"]!.map((x) => ReportListDoc.fromJson(x))),
        totalDocs: json["totalDocs"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        page: json["page"],
        pagingCounter: json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"],
        hasNextPage: json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": docs == null
            ? []
            : List<dynamic>.from(docs!.map((x) => x.toJson())),
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class ReportListDoc {
  String? id;
  CreatedBy? userid;
  String? reason;
  CreatedBy? reportby;
  int? createdTimestamp;
  int? updatedTimestamp;
  CreatedBy? createdBy;
  CreatedBy? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? docId;

  ReportListDoc({
    this.id,
    this.userid,
    this.reason,
    this.reportby,
    this.createdTimestamp,
    this.updatedTimestamp,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.docId,
  });

  factory ReportListDoc.fromJson(Map<String, dynamic> json) => ReportListDoc(
        id: json["_id"],
        userid:
            json["userid"] == null ? null : CreatedBy.fromJson(json["userid"]),
        reason: json["reason"],
        reportby: json["reportby"] == null
            ? null
            : CreatedBy.fromJson(json["reportby"]),
        createdTimestamp: json["createdTimestamp"],
        updatedTimestamp: json["updatedTimestamp"],
        createdBy: json["createdBy"] == null
            ? null
            : CreatedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null
            ? null
            : CreatedBy.fromJson(json["updatedBy"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        docId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userid": userid?.toJson(),
        "reason": reason,
        "reportby": reportby?.toJson(),
        "createdTimestamp": createdTimestamp,
        "updatedTimestamp": updatedTimestamp,
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "id": docId,
      };
}