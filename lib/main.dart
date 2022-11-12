import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game2/home.dart';
import 'package:game2/presentation/screens/home_screen.dart';
import 'AppModule/HomeModule/View/splash.dart';
import 'data/repositories/country_repository.dart';
import 'logic/bloc/countrybloc/country_bloc.dart';
import 'logic/cubit/sortgroupcubit/sort_group_cubit.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CountryRepository>(
        create: (context) => CountryRepository(),
        child: MultiBlocProvider(
            providers: [
              BlocProvider<CountryBloc>(
                create: (context) => CountryBloc(
                  countryRepository:
                      RepositoryProvider.of<CountryRepository>(context),
                ),
              ),
              BlocProvider<SortGroupCubit>(
                create: (context) => SortGroupCubit(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme:
                  ThemeData(primaryColor: const Color.fromRGBO(5, 29, 64, 1)),
              home: SplashScreen(
                title: "Find Your Place",
              ),
              routes: {
                Home.routeName: (ctx) => const Home(),
                HomeScreenn.routeName: (ctx) => const HomeScreenn(),
              },
            )));
  }
}
