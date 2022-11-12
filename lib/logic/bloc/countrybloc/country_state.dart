// part of 'country_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../country_model.dart';

@immutable
abstract class CountryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CountryInitialState extends CountryState {
  @override
  List<Object?> get props => [];
}

class CountryLoadingState extends CountryState {
  @override
  List<Object?> get props => [];
}

class CountryLoadedState extends CountryState {
  CountryLoadedState({
    required this.countryList,
    required this.sortingStatus,
    required this.groupingStatus,
  });

  final List<CountryModel> countryList;
  final String sortingStatus;
  final String groupingStatus;

  @override
  List<Object?> get props => [countryList, sortingStatus, groupingStatus];

  CountryLoadedState copyWith({
    List<CountryModel>? countryList,
    String? sortingStatus,
    String? groupingStatus,
  }) {
    return CountryLoadedState(
      countryList: countryList ?? this.countryList,
      sortingStatus: sortingStatus ?? this.sortingStatus,
      groupingStatus: groupingStatus ?? this.groupingStatus,
    );
  }
}

class CountryErrorState extends CountryState {
  CountryErrorState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
