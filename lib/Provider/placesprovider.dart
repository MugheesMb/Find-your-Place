import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game2/autoComplet.dart';

final placesResultsProvider = ChangeNotifierProvider<PlacesResults>((ref) {
  return PlacesResults();
});

final searchToggleProvider = ChangeNotifierProvider<SearchToggle>((ref) {
  return SearchToggle();
});

class PlacesResults extends ChangeNotifier {
  List<AutoCompleteResult> allReturnedResults = [];
  void setResults(allPlaces) {
    allReturnedResults = allPlaces;
    notifyListeners();
  }
}

class SearchToggle extends ChangeNotifier {
  bool searchToggle = false;

  void toggleSearch() {
    searchToggle = !searchToggle;
    notifyListeners();
  }
}
