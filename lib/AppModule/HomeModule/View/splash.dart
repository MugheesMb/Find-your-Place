import 'dart:async';
import 'package:game2/AppModule/HomeModule/View/HomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState() {
    Timer(const Duration(milliseconds: 6000), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      });
    });

    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 29, 64, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(5, 29, 64, 1),
                  Color.fromRGBO(5, 29, 64, 1),
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0,
              duration: const Duration(milliseconds: 1200),
              child: Center(
                child: Container(
                  height: 240.0,
                  width: 240.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2.0,
                          offset: const Offset(5.0, 3.0),
                          spreadRadius: 2.0,
                        )
                      ]),
                  child: Center(
                    child: Column(
                      children: [
                        ClipOval(
                            child: Image.asset(
                          "assets/world-map.gif",
                        ) //put your logo here
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
          Text(
            "Find Your Place",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 26),
          )
        ],
      ),
    );
  }
}
