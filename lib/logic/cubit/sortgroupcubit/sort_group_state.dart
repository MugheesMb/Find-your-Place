// part of 'sort_group_cubit.dart';

import 'package:equatable/equatable.dart';

class SortGroupState extends Equatable {
  const SortGroupState({required this.sortValue, required this.groupValue});

  final String sortValue;
  final String groupValue;

  @override
  List<Object> get props => [sortValue, groupValue];

  SortGroupState copyWith({
    String? sortValue,
    String? groupValue,
  }) {
    return SortGroupState(
      sortValue: sortValue ?? this.sortValue,
      groupValue: groupValue ?? this.groupValue,
    );
  }
}
