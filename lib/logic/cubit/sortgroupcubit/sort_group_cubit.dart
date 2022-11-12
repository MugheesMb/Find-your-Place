import 'package:game2/logic/cubit/sortgroupcubit/sort_group_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class SortGroupCubit extends Cubit<SortGroupState> {
  SortGroupCubit()
      : super(const SortGroupState(
          sortValue: 'Name',
          groupValue: 'Ungrouped',
        ));

  void onChangeSortOption(String newValue) {
    emit(state.copyWith(sortValue: newValue));
  }

  void onChangeGroupOption(String newValue) {
    emit(state.copyWith(groupValue: newValue));
  }
}
