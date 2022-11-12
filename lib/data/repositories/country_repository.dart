import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../country_model.dart';
import '../constants/constants.dart';

class CountryRepository {
  List<CountryModel> countryList = [];

  Future<List<CountryModel>> getCountries() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;

      for (var element in jsonList) {
        countryList.add(CountryModel.fromJson(element));
      }
      return countryList;
    } else {
      throw Exception('Failed to load countries.');
    }
  }
}
