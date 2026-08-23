class AuthorizedPermissions {
  bool? fullname;
  bool? mobile;
  bool? email;
  bool? dob;
  bool? gender;
  bool? socialmedia;
  bool? videocall;
  bool? audiocall;
  bool? ismute;

  AuthorizedPermissions({
    this.fullname,
    this.mobile,
    this.email,
    this.dob,
    this.gender,
    this.socialmedia,
    this.videocall,
    this.audiocall,
    this.ismute,
  });

  factory AuthorizedPermissions.fromJson(Map<String, dynamic> json) =>
      AuthorizedPermissions(
        fullname: json["fullname"] ?? false,
        mobile: json["mobile"] ?? false,
        email: json["email"] ?? false,
        dob: json["dob"] ?? false,
        gender: json["gender"] ?? false,
        socialmedia: json["socialmedia"] ?? false,
        videocall: json["videocall"] ?? false,
        audiocall: json["audiocall"] ?? false,
        ismute: json["ismute"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        if (fullname != null) "fullname": fullname,
        if (mobile != null) "mobile": mobile,
        if (email != null) "email": email,
        if (dob != null) "dob": dob,
        if (gender != null) "gender": gender,
        if (socialmedia != null) "socialmedia": socialmedia,
        if (videocall != null) "videocall": videocall,
        if (audiocall != null) "audiocall": audiocall,
        if (ismute != null) "ismute": ismute,
      };
}
