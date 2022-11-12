// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   static const routeName = "map-screen";
//   MapScreen({super.key});
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// String _mapStyle = "";
// void initState() {
//   SchedulerBinding.instance.addPostFrameCallback((_) {
//     rootBundle.loadString(FileConstants.mapStyle).then((string) {
//       _mapStyle = string;
//     });
//   });
// }

// class _MapScreenState extends State<MapScreen> {
//   Completer<GoogleMapController> controllerMap = Completer();
//   // final LatLng _center = const LatLng(45.521563, -122.677433);
//   late GoogleMapController newMapController;
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Maps Sample App'),
//         backgroundColor: const Color.fromRGBO(5, 29, 64, 1),
//         elevation: 0,
//       ),
//       body: GoogleMap(
//         mapType: MapType.satellite,
//         myLocationButtonEnabled: true,
//         myLocationEnabled: true,
//         zoomGesturesEnabled: true,
//         zoomControlsEnabled: true,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           controllerMap.complete(controller);
//           newMapController = controller;
//           // newMapController.setMapStyle(_mapStyle);
//         },
//       ),
//     );
//   }
// }

// class FileConstants {
//   static const String mapStyle = "assets/style.txt";
// }
