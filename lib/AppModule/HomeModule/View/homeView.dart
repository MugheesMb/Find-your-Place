import 'package:game2/AppModule/Controller/controller.dart';
import 'package:game2/AppModule/HomeModule/Service/homeService.dart';
import 'package:game2/AppModule/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../country_model.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
  bool resBool = false;
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    _toogleRes(bool val) {
      setState(() {
        widget.resBool = !widget.resBool;
      });
    }

    AuthController controller = Get.put(AuthController());
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Center(
                child: Text(
                  'Filters',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Text("Restuarants"),
              title: Switch(value: widget.resBool, onChanged: _toogleRes),
            ),
            ListTile(
              leading: Icon(
                Icons.train,
              ),
              title: const Text('Page 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Maps"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Center(
            child: textformfeild(
                boolTitleShowHide: true,
                fieldName: "Country Name",
                isObscureText: false,
                returnDatacall: (val) {
                  controller.countryName.value = val;
                }),
          ),
          ElevatedButton(
              onPressed: () async {
                CountryModel Count = await HomeService();
                setState(() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          CountryWidget(countryModel: Count));
                });
              },
              child: const Text("Submit API")),
        ],
      ),
    );
  }
}

class CountryWidget extends StatelessWidget {
  CountryWidget({required this.countryModel, Key? key}) : super(key: key);

  final CountryModel countryModel;

  final NumberFormat populationFormat =
      NumberFormat('###,###,###,###', 'en_US');
  final NumberFormat areaFormat = NumberFormat('###,###,###,###.#', 'en_US');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: GestureDetector(
        onTap: () {
          print("hello");
        },
        child: Text(countryModel.nameCommon,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      contentPadding: const EdgeInsets.only(top: 10),
      insetPadding: const EdgeInsets.symmetric(horizontal: 36),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image.network(
                countryModel.flagPng,
                color: Colors.white.withOpacity(0.25),
                colorBlendMode: BlendMode.modulate,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    titleGenerator('Common Name'),
                    Text(countryModel.nameCommon,
                        style: const TextStyle(fontSize: 12)),
                    const Divider(thickness: 2),
                    titleGenerator('Official Name'),
                    Text(countryModel.nameOfficial,
                        style: const TextStyle(fontSize: 12)),
                    const Divider(thickness: 2),
                    rowGenerator(
                      firstHeader: 'Capital',
                      firstText: countryModel.capital,
                      secondHeader: 'Continent',
                      secondText: countryModel.continents,
                      firstFlex: 7,
                      secondFlex: 4,
                    ),
                    rowGenerator(
                      firstHeader: 'Population',
                      firstText:
                          populationFormat.format(countryModel.population),
                      secondHeader: 'Region',
                      secondText: countryModel.region,
                      firstFlex: 1,
                      secondFlex: 1,
                    ),
                    rowGenerator(
                      firstHeader: 'Area',
                      firstText:
                          '${areaFormat.format(countryModel.area)} km\u{00B2}',
                      secondHeader: 'Subregion',
                      secondText: countryModel.subregion,
                      firstFlex: 1,
                      secondFlex: 2,
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.amber,
                    backgroundColor: const Color.fromRGBO(5, 29, 64, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Explore", style: GoogleFonts.poppins()),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.pin_drop)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

Row rowGenerator({
  required String firstHeader,
  required String firstText,
  required String secondHeader,
  required String secondText,
  required int firstFlex,
  required int secondFlex,
}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      expandedWidgetGenerator(firstHeader, firstText, firstFlex, true),
      expandedWidgetGenerator(secondHeader, secondText, secondFlex, false),
    ],
  );
}

Expanded expandedWidgetGenerator(
        String header, String text, int flex, bool isStart) =>
    Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment:
            isStart ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          titleGenerator(header),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
          const Divider(thickness: 2),
        ],
      ),
    );

Text titleGenerator(String title) => Text(title,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
