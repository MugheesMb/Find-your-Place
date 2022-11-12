class CountryModel {
  const CountryModel({
    required this.nameCommon,
    required this.nameOfficial,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.area,
    required this.population,
    required this.continents,
    required this.flagPng,
    this.unGrouped = 'All Countries',
  });

  final String nameCommon;
  final String nameOfficial;
  final String capital;
  final String region;
  final String subregion;
  final double area;
  final int population;
  final String continents;
  final String flagPng;
  final String unGrouped;

  @override
  List<Object?> get props => [
        nameCommon,
        nameOfficial,
        capital,
        region,
        subregion,
        area,
        population,
        continents,
        flagPng,
      ];

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      nameCommon: json["name"]["common"],
      nameOfficial: json["name"]["official"],
      capital: List<String>.from(
              json["capital"]?.map((cap) => cap) ?? ['No Capital'])
          .toString()
          .replaceAll(']', '')
          .replaceAll('[', ''),
      region: json["region"],
      subregion: json["subregion"] ?? 'No Subregion',
      area: json["area"],
      population: json["population"],
      continents: json["continents"][0],
      flagPng: json["flags"]["png"],
    );
  }
}
