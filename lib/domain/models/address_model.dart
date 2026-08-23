import 'dart:convert';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

class AddressModel {
    PlusCode? plusCode;
    List<AddressResult>? results;
    String? status;

    AddressModel({
        this.plusCode,
        this.results,
        this.status,
    });

    factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
        results: json["results"] == null ? [] : List<AddressResult>.from(json["results"]!.map((x) => AddressResult.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "plus_code": plusCode?.toJson(),
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
    };
}

class PlusCode {
    String? compoundCode;
    String? globalCode;

    PlusCode({
        this.compoundCode,
        this.globalCode,
    });

    factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
    );

    Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
    };
}

class AddressResult {
    List<AddressComponent>? addressComponents;
    String? formattedAddress;
    Geometry? geometry;
    String? placeId;
    PlusCode? plusCode;
    List<String>? types;

    AddressResult({
        this.addressComponents,
        this.formattedAddress,
        this.geometry,
        this.placeId,
        this.plusCode,
        this.types,
    });

    factory AddressResult.fromJson(Map<String, dynamic> json) => AddressResult(
        addressComponents: json["address_components"] == null ? [] : List<AddressComponent>.from(json["address_components"]!.map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
        types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null ? [] : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "place_id": placeId,
        "plus_code": plusCode?.toJson(),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class AddressComponent {
    String? longName;
    String? shortName;
    List<String>? types;

    AddressComponent({
        this.longName,
        this.shortName,
        this.types,
    });

    factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class Geometry {
    AddressLocation? location;
    String? locationType;
    Viewport? viewport;

    Geometry({
        this.location,
        this.locationType,
        this.viewport,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null ? null : AddressLocation.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: json["viewport"] == null ? null : Viewport.fromJson(json["viewport"]),
    );

    Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "location_type": locationType,
        "viewport": viewport?.toJson(),
    };
}

class AddressLocation {
    double? lat;
    double? lng;

    AddressLocation({
        this.lat,
        this.lng,
    });

    factory AddressLocation.fromJson(Map<String, dynamic> json) => AddressLocation(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}

class Viewport {
    AddressLocation? northeast;
    AddressLocation? southwest;

    Viewport({
        this.northeast,
        this.southwest,
    });

    factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: json["northeast"] == null ? null : AddressLocation.fromJson(json["northeast"]),
        southwest: json["southwest"] == null ? null : AddressLocation.fromJson(json["southwest"]),
    );

    Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
    };
}
