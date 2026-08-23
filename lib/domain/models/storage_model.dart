import 'dart:convert';

StorageModel storageModelFromJson(String str) =>
    StorageModel.fromJson(json.decode(str));

String storageModelToJson(StorageModel data) => json.encode(data.toJson());

class StorageModel {
  String? message;
  StorageData? data;
  int? status;
  bool? isSuccess;

  StorageModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory StorageModel.fromJson(Map<String, dynamic> json) => StorageModel(
        message: json["Message"],
        data: json["Data"] == null ? null : StorageData.fromJson(json["Data"]),
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

class StorageData {
  String? msg;
  String? foldersizeinmb;
  String? foldersizeingb;
  String? folder;

  StorageData({
    this.msg,
    this.foldersizeinmb,
    this.foldersizeingb,
    this.folder,
  });

  factory StorageData.fromJson(Map<String, dynamic> json) => StorageData(
        msg: json["msg"] ?? "",
        foldersizeinmb: json["foldersizeinmb"] ?? "0.00",
        foldersizeingb: json["foldersizeingb"] ?? "0.00",
        folder: json["folder"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "foldersizeinmb": foldersizeinmb,
        "foldersizeingb": foldersizeingb,
        "folder": folder,
      };
}
