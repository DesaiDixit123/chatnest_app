import 'dart:convert';

PlanListResponseModel planListResponseModelFromJson(String str) =>
    PlanListResponseModel.fromJson(json.decode(str));

class PlanListResponseModel {
  String? message;
  List<PlanDatum>? data;
  GstModel? gst;
  int? status;
  bool? isSuccess;

  PlanListResponseModel({
    this.message,
    this.data,
    this.gst,
    this.status,
    this.isSuccess,
  });

  factory PlanListResponseModel.fromJson(Map<String, dynamic> json) {
    List<PlanDatum>? plans;
    GstModel? gstModel;

    if (json["Gst"] != null) {
      gstModel = GstModel.fromJson(json["Gst"]);
    }

    if (json["Data"] != null) {
      if (json["Data"] is List) {
        plans = List<PlanDatum>.from(
            (json["Data"] as List).map((x) => PlanDatum.fromJson(x)));
      } else if (json["Data"] is Map) {
        final dataMap = json["Data"] as Map<String, dynamic>;
        if (dataMap["plans"] is List) {
          plans = List<PlanDatum>.from(
              (dataMap["plans"] as List).map((x) => PlanDatum.fromJson(x)));
        }
        if (gstModel == null && dataMap["gst"] != null) {
          gstModel = GstModel.fromJson(dataMap["gst"]);
        }
      }
    }

    return PlanListResponseModel(
      message: json["Message"],
      data: plans,
      gst: gstModel,
      status: json["Status"],
      isSuccess: json["IsSuccess"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "Gst": gst?.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class GstModel {
  double percentage;
  bool status;
  String label;
  String gstNumber;

  GstModel({
    this.percentage = 18.0,
    this.status = true,
    this.label = 'GST',
    this.gstNumber = '',
  });

  bool get isApplicable => status && percentage >= 1.0;

  factory GstModel.fromJson(dynamic json) {
    if (json == null) return GstModel();
    if (json is! Map) return GstModel();
    return GstModel(
      percentage: (json['percentage'] as num?)?.toDouble() ?? 18.0,
      status: json['status'] == null ? true : (json['status'] == true),
      label: json['label']?.toString() ?? 'GST',
      gstNumber: json['gstNumber']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'percentage': percentage,
        'status': status,
        'label': label,
        'gstNumber': gstNumber,
      };
}

class PlanDatum {
  String? id;
  String? title;
  String? description;
  bool? isDefault;
  bool? status;
  PlanPricing? pricing;
  List<PlanFunctionalityItem>? functionalities;
  DateTime? createdAt;

  PlanDatum({
    this.id,
    this.title,
    this.description,
    this.isDefault,
    this.status,
    this.pricing,
    this.functionalities,
    this.createdAt,
  });

  factory PlanDatum.fromJson(Map<String, dynamic> json) => PlanDatum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        isDefault: json["isDefault"] ?? false,
        status: json["status"] ?? true,
        pricing: json["pricing"] == null
            ? null
            : PlanPricing.fromJson(json["pricing"]),
        functionalities: json["functionalities"] == null
            ? null
            : List<PlanFunctionalityItem>.from(
                (json["functionalities"] as List)
                    .map((x) => PlanFunctionalityItem.fromJson(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "isDefault": isDefault,
        "status": status,
        "pricing": pricing?.toJson(),
        "functionalities": functionalities == null
            ? null
            : List<dynamic>.from(functionalities!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
      };

  /// Returns clean normalized list of duration options
  List<DurationOption> get normalizedDurations {
    List<DurationOption> list = [];
    if (pricing?.durationOptions != null &&
        pricing!.durationOptions!.isNotEmpty) {
      list = List<DurationOption>.from(pricing!.durationOptions!);
    } else {
      // Fallback tiers if durationOptions not populated
      if ((pricing?.oneMonthPrice ?? 0) > 0 || (pricing?.monthlyPrice ?? 0) > 0) {
        list.add(DurationOption(
          label: "1 Month (30 Days)",
          days: 30,
          price: (pricing?.oneMonthPrice ?? pricing?.monthlyPrice ?? 0).toDouble(),
        ));
      }
      if ((pricing?.threeMonthPrice ?? 0) > 0) {
        list.add(DurationOption(
          label: "3 Months (90 Days)",
          days: 90,
          price: (pricing?.threeMonthPrice ?? 0).toDouble(),
        ));
      }
      if ((pricing?.sixMonthPrice ?? 0) > 0) {
        list.add(DurationOption(
          label: "6 Months (180 Days)",
          days: 180,
          price: (pricing?.sixMonthPrice ?? 0).toDouble(),
        ));
      }
      if ((pricing?.twelveMonthPrice ?? 0) > 0 || (pricing?.yearlyPrice ?? 0) > 0) {
        list.add(DurationOption(
          label: "1 Year (365 Days)",
          days: 365,
          price: (pricing?.twelveMonthPrice ?? pricing?.yearlyPrice ?? 0).toDouble(),
        ));
      }
    }

    if (list.isEmpty) {
      list.add(DurationOption(
        label: "1 Month (30 Days)",
        days: 30,
        price: 0,
      ));
    }
    return list;
  }
}

class PlanPricing {
  List<DurationOption>? durationOptions;
  num? oneMonthPrice;
  num? threeMonthPrice;
  num? sixMonthPrice;
  num? twelveMonthPrice;
  num? monthlyPrice;
  num? yearlyPrice;

  PlanPricing({
    this.durationOptions,
    this.oneMonthPrice,
    this.threeMonthPrice,
    this.sixMonthPrice,
    this.twelveMonthPrice,
    this.monthlyPrice,
    this.yearlyPrice,
  });

  factory PlanPricing.fromJson(Map<String, dynamic> json) => PlanPricing(
        durationOptions: json["durationOptions"] == null
            ? null
            : List<DurationOption>.from(
                (json["durationOptions"] as List)
                    .map((x) => DurationOption.fromJson(x))),
        oneMonthPrice: json["oneMonthPrice"] ?? 0,
        threeMonthPrice: json["threeMonthPrice"] ?? 0,
        sixMonthPrice: json["sixMonthPrice"] ?? 0,
        twelveMonthPrice: json["twelveMonthPrice"] ?? 0,
        monthlyPrice: json["monthlyPrice"] ?? 0,
        yearlyPrice: json["yearlyPrice"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "durationOptions": durationOptions == null
            ? null
            : List<dynamic>.from(durationOptions!.map((x) => x.toJson())),
        "oneMonthPrice": oneMonthPrice,
        "threeMonthPrice": threeMonthPrice,
        "sixMonthPrice": sixMonthPrice,
        "twelveMonthPrice": twelveMonthPrice,
        "monthlyPrice": monthlyPrice,
        "yearlyPrice": yearlyPrice,
      };
}

class DurationOption {
  String? label;
  int? days;
  double? price;

  DurationOption({
    this.label,
    this.days,
    this.price,
  });

  factory DurationOption.fromJson(Map<String, dynamic> json) => DurationOption(
        label: json["label"]?.toString(),
        days: json["days"] is int
            ? json["days"]
            : int.tryParse(json["days"]?.toString() ?? "30") ?? 30,
        price: json["price"] is num
            ? (json["price"] as num).toDouble()
            : double.tryParse(json["price"]?.toString() ?? "0") ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "days": days,
        "price": price,
      };
}

class PlanFunctionalityItem {
  String? id;
  FunctionalityDetail? functionalityId;
  int? monthlyCallLimit;
  int? friendLimit;

  PlanFunctionalityItem({
    this.id,
    this.functionalityId,
    this.monthlyCallLimit,
    this.friendLimit,
  });

  factory PlanFunctionalityItem.fromJson(Map<String, dynamic> json) =>
      PlanFunctionalityItem(
        id: json["_id"],
        functionalityId: json["functionalityId"] == null
            ? null
            : (json["functionalityId"] is Map<String, dynamic>
                ? FunctionalityDetail.fromJson(json["functionalityId"])
                : FunctionalityDetail(id: json["functionalityId"].toString())),
        monthlyCallLimit: json["monthlyCallLimit"],
        friendLimit: json["friendLimit"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "functionalityId": functionalityId?.toJson(),
        "monthlyCallLimit": monthlyCallLimit,
        "friendLimit": friendLimit,
      };

  String get name => functionalityId?.name ?? "Feature";
}

class FunctionalityDetail {
  String? id;
  String? name;

  FunctionalityDetail({
    this.id,
    this.name,
  });

  factory FunctionalityDetail.fromJson(Map<String, dynamic> json) =>
      FunctionalityDetail(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class UserSubscriptionModel {
  String? planId;
  String? planTitle;
  int? durationDays;
  String? durationLabel;
  double? price;
  String? currency;
  DateTime? startDate;
  DateTime? expiryDate;
  String? status;
  int? remainingDays;
  bool? isExpired;
  String? paymentId;
  String? orderId;
  String? invoiceNumber;
  List<PlanFunctionalityItem>? functionalities;

  UserSubscriptionModel({
    this.planId,
    this.planTitle,
    this.durationDays,
    this.durationLabel,
    this.price,
    this.currency,
    this.startDate,
    this.expiryDate,
    this.status,
    this.remainingDays,
    this.isExpired,
    this.paymentId,
    this.orderId,
    this.invoiceNumber,
    this.functionalities,
  });

  bool get isActive =>
      status == 'active' &&
      !(isExpired ?? false) &&
      (remainingDays ?? 0) > 0;

  bool hasFeature(String featureName) {
    if (!isActive) return false;
    if (functionalities == null || functionalities!.isEmpty) return false;
    final target = featureName.toLowerCase().trim();
    return functionalities!.any((f) {
      final name = (f.functionalityId?.name ?? f.name).toLowerCase().trim();
      if (name.isEmpty) return false;
      return name == target ||
          name.contains(target) ||
          target.contains(name) ||
          (target == 'meeting' && name == 'session') ||
          (target == 'session' && name == 'meeting') ||
          (target == 'group' && name == 'community') ||
          (target == 'community' && name == 'group') ||
          (target == 'product' && name == 'marketplace') ||
          (target == 'marketplace' && name == 'product');
    });
  }

  bool get canAccessChat => hasFeature('Chat');
  bool get canAccessCommunity => hasFeature('Community') || hasFeature('Group');
  bool get canAccessStatus => true; // Social status updates
  bool get canAccessAudioCall => hasFeature('Audio') || hasFeature('Call');
  bool get canAccessVideoCall => hasFeature('Video') || hasFeature('Call');
  bool get canAccessCalls => canAccessAudioCall || canAccessVideoCall;
  bool get canAccessBroadcast => hasFeature('Broadcast');
  bool get canAccessSession => hasFeature('Session') || hasFeature('Meeting');
  bool get canAccessMarketplace => hasFeature('Marketplace') || hasFeature('Product');

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      UserSubscriptionModel(
        planId: json["planId"]?.toString(),
        planTitle: json["planTitle"]?.toString(),
        durationDays: json["durationDays"] is int
            ? json["durationDays"]
            : int.tryParse(json["durationDays"]?.toString() ?? "0") ?? 0,
        durationLabel: json["durationLabel"]?.toString(),
        price: json["price"] is num
            ? (json["price"] as num).toDouble()
            : double.tryParse(json["price"]?.toString() ?? "0") ?? 0.0,
        currency: json["currency"]?.toString() ?? "INR",
        startDate: json["startDate"] == null
            ? null
            : DateTime.tryParse(json["startDate"].toString()),
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.tryParse(json["expiryDate"].toString()),
        status: json["status"]?.toString(),
        remainingDays: json["remainingDays"] is int
            ? json["remainingDays"]
            : int.tryParse(json["remainingDays"]?.toString() ?? "0") ?? 0,
        isExpired: json["isExpired"] ?? false,
        paymentId: json["paymentId"]?.toString(),
        orderId: json["orderId"]?.toString(),
        invoiceNumber: json["invoiceNumber"]?.toString(),
        functionalities: json["functionalities"] == null
            ? null
            : List<PlanFunctionalityItem>.from(
                (json["functionalities"] as List)
                    .map((x) => PlanFunctionalityItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "planId": planId,
        "planTitle": planTitle,
        "durationDays": durationDays,
        "durationLabel": durationLabel,
        "price": price,
        "currency": currency,
        "startDate": startDate?.toIso8601String(),
        "expiryDate": expiryDate?.toIso8601String(),
        "status": status,
        "remainingDays": remainingDays,
        "isExpired": isExpired,
        "paymentId": paymentId,
        "orderId": orderId,
        "invoiceNumber": invoiceNumber,
        "functionalities": functionalities == null
            ? null
            : List<dynamic>.from(functionalities!.map((x) => x.toJson())),
      };
}
