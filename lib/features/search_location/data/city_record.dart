import 'dart:convert';

/// Persistent representation of a saved city: display name plus the
/// precise coordinates returned by the Geocoding API.
///
/// Coordinates are used for all weather lookups so that ambiguous city
/// names (e.g. "Springfield") always resolve to the city the user chose.
class CityRecord {
  const CityRecord({
    required this.name,
    required this.lat,
    required this.lon,
  });

  final String name;
  final double lat;
  final double lon;

  Map<String, dynamic> toJson() => {'name': name, 'lat': lat, 'lon': lon};

  factory CityRecord.fromJson(Map<String, dynamic> json) => CityRecord(
        name: json['name'] as String,
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
      );

  String toJsonString() => jsonEncode(toJson());

  factory CityRecord.fromJsonString(String s) =>
      CityRecord.fromJson(jsonDecode(s) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      other is CityRecord &&
      other.name == name &&
      other.lat == lat &&
      other.lon == lon;

  @override
  int get hashCode => Object.hash(name, lat, lon);
}
