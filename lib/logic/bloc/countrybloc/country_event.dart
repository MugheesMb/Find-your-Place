// part of 'country_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CountryEvent extends Equatable {
  const CountryEvent();
}

class LoadCountryEvent extends CountryEvent {
  @override
  List<Object?> get props => [];
}

class ChangeGroupAndSortEvent extends CountryEvent {
  const ChangeGroupAndSortEvent(
      {required this.sortValue, required this.groupValue});

  final String sortValue;
  final String groupValue;

  @override
  List<Object?> get props => [sortValue, groupValue];
}
