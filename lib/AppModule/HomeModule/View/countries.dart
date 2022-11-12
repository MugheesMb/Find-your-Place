// import 'package:api_test/presentation/screens/home_screen.dart';
// import 'package:flutter/material.dart';

// class Countries extends StatefulWidget {
//   const Countries({super.key});

//   @override
//   State<Countries> createState() => _CountriesState();
// }

// class _CountriesState extends State<Countries> {
//   @override
//   Widget build(BuildContext context) {
//     return return RepositoryProvider<CountryRepository>(
//         create: (context) => CountryRepository(),
//         child: MultiBlocProvider(
//           providers: [
//             BlocProvider<CountryBloc>(
//               create: (context) => CountryBloc(
//                 countryRepository:
//                     RepositoryProvider.of<CountryRepository>(context),
//               ),
//             ),
//             BlocProvider<SortGroupCubit>(
//               create: (context) => SortGroupCubit(),
//             ),
//           ],
//           child: HomeScreenn(),
//           )
//           );
//   }
// }