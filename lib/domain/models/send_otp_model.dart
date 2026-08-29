import 'dart:convert';

SendOtpModel sendOtpModelFromJson(String str) =>
    SendOtpModel.fromJson(json.decode(str));

class SendOtpModel {
  String message;
  SendOtpData? data;
  int status;
  bool isSuccess;

  SendOtpModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
        message: json["Message"],
        data: json["Data"] == null || json["Data"] == 0
            ? null
            : SendOtpData.fromJson(json["Data"]),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data!.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class SendOtpData {
  String? key;
  String? userid;
  String? demoOtp;   // ✅ ADD THIS

  SendOtpData({
    this.key,
    this.userid,
    this.demoOtp,
  });

  factory SendOtpData.fromJson(Map<String, dynamic> json) => SendOtpData(
        key: json["key"] ?? "",
        userid: json["userid"] ?? "",
        demoOtp: (json["demo_otp"] ?? json["otpLogin"] ?? json["OtpLOgin"] ?? "").toString(),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "userid": userid,
        "demo_otp": demoOtp,
      };
}
