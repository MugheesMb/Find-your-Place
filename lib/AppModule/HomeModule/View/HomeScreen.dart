import 'package:game2/AppModule/HomeModule/View/map.dart';
import 'package:game2/home.dart';
import 'package:game2/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 29, 64, 1),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose one",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 26),
            ),
            const SizedBox(
              height: 30,
            ),
            FlipCard(
              fill: Fill
                  .none, // Fill the back side of the card to make in the same size as the front.
              direction: FlipDirection.HORIZONTAL, // default
              front: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                height: size.height / 3,
                width: size.width / 1.4,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: 280,
                        height: 280,
                        child: Image.asset("assets/map-pin2.gif")),
                  ],
                )),
              ),
              back: Container(
                height: size.height / 3,
                width: size.width / 1.4,
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Find Nearby Facilities",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        "Do you want to find all the necessary and important to live Facilities? Jump onto our customized map to enter a world where you can find all needed facilities in any area",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15)),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Home.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.amber,
                              backgroundColor:
                                  const Color.fromRGBO(5, 29, 64, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Explore"),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.pin_drop)
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            FlipCard(
              fill: Fill
                  .none, // Fill the back side of the card to make in the same size as the front.
              direction: FlipDirection.HORIZONTAL, // default
              front: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                height: size.height / 3,
                width: size.width / 1.4,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: 280,
                        height: 280,
                        child: Image.asset("assets/world-pin.gif")),
                  ],
                )),
              ),
              back: Container(
                  height: size.height / 3,
                  width: size.width / 1.4,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Get Countries Details",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                          "Do you want to find all the necessary and important information for a country? Jump onto our list of all the countries of the world where you can find all needed information of any country",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 15)),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(HomeScreenn.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.amber,
                                backgroundColor:
                                    const Color.fromRGBO(5, 29, 64, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Explore"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.map_outlined)
                              ],
                            )),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
