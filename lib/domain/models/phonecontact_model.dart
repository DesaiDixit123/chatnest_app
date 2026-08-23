class PhoneContact {
  String? name;
  List<String>? mobile;

  PhoneContact({
    this.name,
    this.mobile,
  });

  factory PhoneContact.fromJson(Map<String, dynamic> json) => PhoneContact(
        name: json["name"],
        mobile: json["mobileno"] == null
            ? []
            : List<String>.from(json["mobileno"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobileno":
            mobile == null ? [] : List<dynamic>.from(mobile!.map((x) => x)),
      };
}
