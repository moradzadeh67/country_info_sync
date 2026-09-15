class HeritageSite {
  final String name;
  final String countryName;
  final String description;
  final double lat;
  final double lng;

  HeritageSite({
    required this.name,
    required this.countryName,
    required this.description,
    required this.lat,
    required this.lng,
  });

  factory HeritageSite.fromJson(Map<String, dynamic> json) {
    return HeritageSite(
      name: json['name']?.toString() ?? '',
      countryName: json['countryName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
