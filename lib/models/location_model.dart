
import 'package:hive/hive.dart';

part 'location_model.g.dart';

@HiveType(typeId: 0)
class LocationModel extends HiveObject {
  @HiveField(0)
  int id; 

  @HiveField(1)
  String name;

  @HiveField(2)
  String region;

  @HiveField(3)
  String country;

  @HiveField(4)
  double lat;

  @HiveField(5)
  double lon;

  @HiveField(6)
  String url;

  LocationModel({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'url': url,
    };
  }

  // Optional: copyWith method (not generated like in freezed)
  LocationModel copyWith({
    int? id,
    String? name,
    String? region,
    String? country,
    double? lat,
    double? lon,
    String? url,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      url: url ?? this.url,
    );
  }

  // Optional: Equality and hashCode (like freezed generates)
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LocationModel &&
            id == other.id &&
            name == other.name &&
            region == other.region &&
            country == other.country &&
            lat == other.lat &&
            lon == other.lon &&
            url == other.url);
  }

  @override
  int get hashCode => Object.hash(id, name, region, country, lat, lon, url);

  @override
  String toString() {
    return 'LocationModel(id: $id, name: $name, region: $region, country: $country, lat: $lat, lon: $lon, url: $url)';
  }
}