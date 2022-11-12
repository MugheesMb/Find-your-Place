import 'package:game2/logic/bloc/countrybloc/country_event.dart';
import 'package:game2/logic/bloc/countrybloc/country_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../country_model.dart';
import '../../../data/repositories/country_repository.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc({required this.countryRepository})
      : super(CountryInitialState()) {
    on<LoadCountryEvent>((event, emit) async {
      emit(CountryLoadingState());
      try {
        List<CountryModel> countryList = await countryRepository.getCountries();
        emit(
          CountryLoadedState(
            countryList: countryList,
            sortingStatus: 'Name',
            groupingStatus: 'Ungrouped',
          ),
        );
      } catch (error) {
        emit(CountryErrorState(error: error.toString()));
      }
    });
    on<ChangeGroupAndSortEvent>(
      (event, emit) {
        emit((state as CountryLoadedState).copyWith(
            groupingStatus: event.groupValue, sortingStatus: event.sortValue));
      },
    );
  }

  final CountryRepository countryRepository;
}
