import 'package:google_maps_flutter/google_maps_flutter.dart';  

class LocationModel {
  String? name;
  LatLng? latLng;

  LocationModel(this.name, this.latLng);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latLng?.latitude,
      'longitude': latLng?.longitude,
    };
  }

    factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      map['name'],
      LatLng(map['latitude'], map['longitude']),
    );
  }
}
