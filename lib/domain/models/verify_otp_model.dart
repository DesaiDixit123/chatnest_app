import 'dart:convert';

VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));

class VerifyOtpModel {
    String message;
    VerifyOtpData data;
    int status;
    bool isSuccess;

    VerifyOtpModel({
        required this.message,
        required this.data,
        required this.status,
        required this.isSuccess,
    });

    factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
        message: json["Message"],
        data: VerifyOtpData.fromJson(json["Data"]),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
    };
}

class VerifyOtpData {
    String token;
    String s3Url;

    VerifyOtpData({
        required this.token,
        required this.s3Url,
    });

    factory VerifyOtpData.fromJson(Map<String, dynamic> json) => VerifyOtpData(
        token: json["token"],
        s3Url: json["s3Url"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "s3Url": s3Url,
    };
}
