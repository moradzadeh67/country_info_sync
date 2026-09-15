class CountryInsight {
  final String countryName;
  final String extract;
  final String sourceUrl;

  CountryInsight({required this.countryName, required this.extract, required this.sourceUrl});

  Map<String, dynamic> toMap() {
    return {'countryName': countryName, 'extract': extract, 'sourceUrl': sourceUrl};
  }

  factory CountryInsight.fromMap(Map<dynamic, dynamic> map) {
    return CountryInsight(
      countryName: map['countryName'] ?? '',
      extract: map['extract'] ?? '',
      sourceUrl: map['sourceUrl'] ?? '',
    );
  }
}
