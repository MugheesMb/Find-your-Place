import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/constants/constants.dart';
import '../../logic/bloc/countrybloc/country_bloc.dart';
import '../../logic/bloc/countrybloc/country_event.dart';
import '../../logic/cubit/sortgroupcubit/sort_group_cubit.dart';
import '../../logic/cubit/sortgroupcubit/sort_group_state.dart';

class SortGroupWidget extends StatelessWidget {
  const SortGroupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SortGroupCubit, SortGroupState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 10),
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildDropDownButton('sort', context, state),
              buildDropDownButton('group', context, state),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () {
                  BlocProvider.of<CountryBloc>(context).add(
                    ChangeGroupAndSortEvent(
                      sortValue: state.sortValue,
                      groupValue: state.groupValue,
                    ),
                  );
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  buildDropDownButton(String type, BuildContext context, SortGroupState state) {
    switch (type) {
      case 'sort':
        return Column(
          children: [
            Text('Sorted By',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              dropdownColor: Colors.deepPurple,
              value: state.sortValue,
              items: sortItems.map(buildMenuItem).toList(),
              onChanged: (value) {
                BlocProvider.of<SortGroupCubit>(context)
                    .onChangeSortOption(value!);
              },
            ),
          ],
        );
      case 'group':
        return Column(
          children: [
            Text('Grouped By',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              dropdownColor: Colors.deepPurple,
              value: state.groupValue,
              items: groupItems.map(buildMenuItem).toList(),
              onChanged: (value) {
                BlocProvider.of<SortGroupCubit>(context)
                    .onChangeGroupOption(value!);
              },
            ),
          ],
        );
    }
  }
}

DropdownMenuItem<String> buildMenuItem(String item) {
  return DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: GoogleFonts.poppins(color: Colors.white),
    ),
  );
}
