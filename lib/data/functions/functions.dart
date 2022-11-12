import 'dart:collection';

import 'package:collection/collection.dart';

import '../../country_model.dart';

Map<String, List<CountryModel>> generateCountryMap(
  String groupOption,
  List<CountryModel> countryList,
) {
  final Map<String, List<CountryModel>> groupedCountryMap;

  switch (groupOption) {
    case 'Continent':
      groupedCountryMap =
          groupBy(countryList, (CountryModel country) => country.continents);

      final sortedKeyCountryMap = SplayTreeMap<String, List<CountryModel>>.from(
          groupedCountryMap, (key1, key2) => key1.compareTo(key2));

      return sortedKeyCountryMap;

    case 'First Letter':
      groupedCountryMap =
          groupBy(countryList, (CountryModel country) => country.nameCommon[0]);

      final sortedKeyCountryMap = SplayTreeMap<String, List<CountryModel>>.from(
          groupedCountryMap, (key1, key2) => key1.compareTo(key2));
      return sortedKeyCountryMap;

    case 'Region':
      groupedCountryMap =
          groupBy(countryList, (CountryModel country) => country.region);

      final sortedKeyCountryMap = SplayTreeMap<String, List<CountryModel>>.from(
          groupedCountryMap, (key1, key2) => key1.compareTo(key2));

      return sortedKeyCountryMap;

    case 'Subregion':
      groupedCountryMap =
          groupBy(countryList, (CountryModel country) => country.subregion);

      final sortedKeyCountryMap = SplayTreeMap<String, List<CountryModel>>.from(
          groupedCountryMap, (key1, key2) => key1.compareTo(key2));

      return sortedKeyCountryMap;

    case 'Ungrouped':
      groupedCountryMap =
          groupBy(countryList, (CountryModel country) => country.unGrouped);

      final sortedKeyCountryMap = SplayTreeMap<String, List<CountryModel>>.from(
          groupedCountryMap, (key1, key2) => key1.compareTo(key2));

      return sortedKeyCountryMap;

    default:
      groupedCountryMap =
          groupBy(countryList, (CountryModel country) => country.unGrouped);

      final sortedKeyCountryMap = SplayTreeMap<String, List<CountryModel>>.from(
          groupedCountryMap, (key1, key2) => key1.compareTo(key2));

      return sortedKeyCountryMap;
  }
}

int generateSorting(
  String sortingStatus,
  CountryModel country1,
  CountryModel country2,
) {
  switch (sortingStatus) {
    case 'Name':
      return country1.nameCommon.compareTo(country2.nameCommon);
    case 'Area':
      return country2.area.compareTo(country1.area);
    case 'Population':
      return country2.population.compareTo(country1.population);
    default:
      return country1.nameCommon.compareTo(country2.nameCommon);
  }
}
