import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game2/Provider/placesprovider.dart';
import 'package:game2/autoComplet.dart';
import 'package:game2/map_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

Timer? debounce;

class Home extends ConsumerStatefulWidget {
  static const routeName = "map-screen";
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Completer<GoogleMapController> controller1 = Completer();

  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  // bool getDirections = false;
  bool mapT = false;
  var placesResult;
  bool restaurant = false;
  bool food = false;
  bool school = false;
  bool bar = false;
  bool lodging = false;
  bool hospital = false;
  bool store = false;
  bool locality = false;

  Color like = Colors.red;

  int markerIdCounter = 1;
  int polylineIdCounter = 1;

  var radiusValue = 3000.0;

  var tappedPoint;
  List allFavoritePlaces = [];

  String tokenKey = '';

  Set<Marker> _markers = Set<Marker>();
  Set<Marker> _markersDupe = Set<Marker>();

  Set<Circle> _circles = Set<Circle>();
  late PageController _pageController;
  int prevPage = 0;
  var tappedPlaceDetail;
  String placeImg = '';
  var photoGalleryIndex = 0;
  bool showBlankCard = false;
  bool isReviews = true;
  bool isPhotos = false;

  final key = 'your key';

  var selectedPlaceDetails;

  TextEditingController searchController = TextEditingController();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  void _setMarker(point) {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {
          Text('daasdas');
          print(searchController.text);
        },
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });
  }

  _setNearMarker(LatLng point, String label, List types, String status) async {
    var counter = markerIdCounter++;

    final Uint8List markerIcon;
    if (types.contains('restaurant') && restaurant)
      markerIcon =
          await getBytesFromAsset('assets/mapicons/restaurants.png', 85);
    else if (types.contains('food') && food)
      markerIcon = await getBytesFromAsset('assets/mapicons/food.png', 85);
    else if (types.contains('school') && school)
      markerIcon = await getBytesFromAsset('assets/mapicons/schools.png', 85);
    else if (types.contains('bar') && bar)
      markerIcon = await getBytesFromAsset('assets/mapicons/bars.png', 85);
    else if (types.contains('lodging') && lodging)
      markerIcon = await getBytesFromAsset('assets/mapicons/hotels.png', 85);
    else if (types.contains('hospital') && hospital)
      markerIcon =
          await getBytesFromAsset('assets/mapicons/health-medical.png', 85);
    else if (types.contains('store') && store)
      markerIcon =
          await getBytesFromAsset('assets/mapicons/retail-stores.png', 85);
    else if (types.contains('locality') && restaurant)
      markerIcon =
          await getBytesFromAsset('assets/mapicons/local-services.png', 85);
    else
      markerIcon = await getBytesFromAsset('assets/mapicons/places.png', 85);

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markerIcon));

    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final Marker marker2 = Marker(
      markerId: MarkerId("marker_1"),
      position: LatLng(37.42796133580664, -122.085749655962),
      icon: BitmapDescriptor.defaultMarker);

  @override
  void initState() {
    // TODO: implement initState

    _markers.add(marker2);
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      cardTapped = false;
      photoGalleryIndex = 1;
      showBlankCard = false;
      goToTappedPlace();
      fetchImage();
    }
  }

  void fetchImage() async {
    if (_pageController.page !=
        null) if (allFavoritePlaces[_pageController.page!.toInt()]
            ['photos'] !=
        null) {
      setState(() {
        placeImg = allFavoritePlaces[_pageController.page!.toInt()]['photos'][0]
            ['photo_reference'];
      });
    } else {
      placeImg = '';
    }
  }

  Future<void> goToTappedPlace() async {
    final GoogleMapController controller2 = await controller1.future;

    _markers = {};

    var selectedPlace = allFavoritePlaces[_pageController.page!.toInt()];

    setState(() {
      mapT = true;
    });

    _setNearMarker(
        LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        selectedPlace['name'] ?? 'no name',
        selectedPlace['types'],
        selectedPlace['business_status'] ?? 'none');

    controller2.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        zoom: 18.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  void _setCircle(LatLng point) async {
    final GoogleMapController controller = await controller1.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
    setState(() {
      _circles.add(Circle(
          circleId: CircleId('mb'),
          center: point,
          fillColor: Colors.blue.withOpacity(0.1),
          radius: radiusValue,
          strokeColor: Color.fromARGB(255, 0, 0, 0),
          strokeWidth: 3));
      // getDirections = false;
      searchToggle = false;
      radiusSlider = true;
    });
  }

  Widget NearMe() => (IconButton(
      onPressed: () {
        if (debounce?.isActive ?? false) debounce?.cancel();
        debounce = Timer(Duration(seconds: 2), () async {
          var placesResult = await MapServices()
              .getPlaceDetails(tappedPoint, radiusValue.toInt());
          List<dynamic> placesWithin = placesResult['results'] as List;

          allFavoritePlaces = placesWithin;

          tokenKey = placesResult['next_page_token'] ?? 'none';
          _markers = {};
          placesWithin.forEach((element) {
            restaurant:
            _setNearMarker(
              LatLng(element['geometry']['location']['lat'],
                  element['geometry']['location']['lng']),
              element['name'],
              element['types'],
              element['business_status'] ?? 'not available',
            );
          });
          _markersDupe = _markers;
          pressedNear = true;
        });
      },
      icon: Icon(
        Icons.near_me,
        color: Colors.blue,
      )));

  Widget SearchBar(SearchToggle searchFlag, PlacesResults allSearchResults) =>
      (Padding(
        padding: const EdgeInsets.fromLTRB(45.0, 60.0, 35.0, 25.0),
        child: Column(children: [
          Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  border: InputBorder.none,
                  hintText: 'Search',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          searchToggle = false;
                          searchController.text = '';
                          _markers = {};
                          searchFlag.toggleSearch();
                        });
                      },
                      icon: Icon(Icons.close))),
              onChanged: (value) {
                if (debounce?.isActive ?? false) debounce?.cancel();
                debounce = Timer(Duration(milliseconds: 700), () async {
                  if (value.length > 2) {
                    if (!searchFlag.searchToggle) {
                      searchFlag.toggleSearch();
                      _markers = {};
                    }
                    List<AutoCompleteResult> searchResults =
                        await MapServices().searchPlaces(value);

                    allSearchResults.setResults(searchResults);
                  } else {
                    List<AutoCompleteResult> emptyList = [];
                    allSearchResults.setResults(emptyList);
                  }
                });
              },
            ),
          )
        ]),
      ));
  restaurantFunc(bool val) {
    setState(() {
      restaurant = !restaurant;
    });
  }

  foodFunc(bool val) {
    setState(() {
      food = !food;
    });
  }

  schoolFunc(bool val) {
    setState(() {
      school = !school;
    });
  }

  barFunc(bool val) {
    setState(() {
      bar = !bar;
    });
  }

  lodgingFunc(bool val) {
    setState(() {
      lodging = !lodging;
    });
  }

  hospitalFunc(bool val) {
    setState(() {
      hospital = !hospital;
    });
  }

  storeFunc(bool val) {
    setState(() {
      store = !store;
    });
  }

  localityFunc(bool val) {
    setState(() {
      locality = !locality;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final allSearchResults = ref.watch(placesResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(child: Image.asset("assets/logo-png.png")),
            ),
            Center(
                child: Text("Filters",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor))),
            ListTile(
              leading: Switch(
                value: restaurant,
                onChanged: restaurantFunc,
                activeColor: Theme.of(context).primaryColor,
              ),
              title: Row(
                children: [
                  Text("Restuarants",
                      style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.restaurant_outlined,
                      color: Theme.of(context).primaryColor),
                ],
              ),
            ),
            ListTile(
              leading: Switch(
                value: food,
                onChanged: foodFunc,
                activeColor: Theme.of(context).primaryColor,
              ),
              title: Row(
                children: [
                  Text("Food",
                      style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.food_bank, color: Theme.of(context).primaryColor),
                ],
              ),
            ),
            ListTile(
              leading: Switch(
                value: school,
                onChanged: schoolFunc,
                activeColor: Theme.of(context).primaryColor,
              ),
              title: Row(
                children: [
                  Text("School",
                      style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.school, color: Theme.of(context).primaryColor),
                ],
              ),
            ),
            ListTile(
              leading: Switch(
                value: bar,
                onChanged: barFunc,
                activeColor: Theme.of(context).primaryColor,
              ),
              title: Row(
                children: [
                  Text("Bar",
                      style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.local_drink,
                      color: Theme.of(context).primaryColor),
                ],
              ),
            ),
            ListTile(
              leading: Switch(
                value: lodging,
                onChanged: lodgingFunc,
                activeColor: Theme.of(context).primaryColor,
              ),
              title: Row(
                children: [
                  Text("Hotel",
                      style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.hotel, color: Theme.of(context).primaryColor),
                ],
              ),
            ),
            ListTile(
              leading: Switch(
                value: hospital,
                onChanged: hospitalFunc,
                activeColor: Theme.of(context).primaryColor,
              ),
              title: Row(
                children: [
                  Text("Hospital",
                      style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.local_hospital,
                      color: Theme.of(context).primaryColor),
                ],
              ),
            ),
            ListTile(
              leading: Switch(
                value: store,
                onChanged: storeFunc,
                activeColor: Theme.of(context).primaryColor,
              ),
              title: Row(
                children: [
                  Text("Store",
                      style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.store_mall_directory,
                      color: Theme.of(context).primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Maps"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: GoogleMap(
                    mapType: mapT ? MapType.satellite : MapType.normal,
                    markers: _markers,
                    // polylines: _polylines,
                    circles: _circles,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      controller1.complete(controller);
                    },
                    onTap: (point) {
                      tappedPoint = point;
                      _setCircle(point);
                    },
                  ),
                ),
                searchToggle
                    ? SearchBar(searchFlag, allSearchResults)
                    : Container(),
                searchFlag.searchToggle
                    ? allSearchResults.allReturnedResults.length != 0
                        ? Positioned(
                            top: 130.0,
                            left: 15.0,
                            child: Container(
                              height: 200.0,
                              width: screenWidth - 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: ListView(
                                children: [
                                  ...allSearchResults.allReturnedResults
                                      .map((e) => buildListItem(e, searchFlag))
                                ],
                              ),
                            ))
                        : Positioned(
                            top: 100.0,
                            left: 15.0,
                            child: Container(
                              height: 200.0,
                              width: screenWidth - 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: Center(
                                child: Column(children: [
                                  Text('No results to show',
                                      style: TextStyle(
                                          fontFamily: 'WorkSans',
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width: 125.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        searchFlag.toggleSearch();
                                      },
                                      child: Center(
                                        child: Text(
                                          'Close this',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'WorkSans',
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ))
                    : Container(),
                radiusSlider
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                        child: Container(
                          height: 50.0,
                          color: Colors.black.withOpacity(0.2),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Slider(
                                      max: 7000.0,
                                      min: 1000.0,
                                      value: radiusValue,
                                      onChanged: (newVal) {
                                        radiusValue = newVal;
                                        pressedNear = false;
                                        _setCircle(tappedPoint);
                                      })),
                              //!pressedNear
                              NearMe(),

                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      radiusSlider = false;
                                      pressedNear = false;
                                      cardTapped = false;
                                      radiusValue = 3000.0;
                                      _circles = {};
                                      _markers = {};
                                      allFavoritePlaces = [];
                                      mapT = false;
                                    });
                                  },
                                  icon: Icon(Icons.close, color: Colors.red))
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Container(),
                pressedNear
                    ? Positioned(
                        bottom: 20.0,
                        child: Container(
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: allFavoritePlaces.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _nearbyPlacesList(index);
                              }),
                        ))
                    : Container(),
                cardTapped
                    ? Positioned(
                        top: 100.0,
                        left: 85.0,
                        child: FlipCard(
                          front: Container(
                            height: 250.0,
                            width: 175.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: SingleChildScrollView(
                              child: Column(children: [
                                Container(
                                  height: 150.0,
                                  width: 175.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(placeImg != ''
                                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                              : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  padding: EdgeInsets.all(7.0),
                                  width: 175.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address: ',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                          width: 105.0,
                                          child: Text(
                                            tappedPlaceDetail[
                                                    'formatted_address'] ??
                                                'none given',
                                            style: TextStyle(
                                                fontFamily: 'WorkSans',
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400),
                                          ))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                                  width: 175.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contact: ',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                          width: 105.0,
                                          child: Text(
                                            tappedPlaceDetail[
                                                    'formatted_phone_number'] ??
                                                'none given',
                                            style: TextStyle(
                                                fontFamily: 'WorkSans',
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400),
                                          ))
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          back: Container(
                            height: 300.0,
                            width: 225.0,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isReviews = true;
                                            isPhotos = false;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 700),
                                          curve: Curves.easeIn,
                                          padding: EdgeInsets.fromLTRB(
                                              7.0, 4.0, 7.0, 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              color: isReviews
                                                  ? Colors.green.shade300
                                                  : Colors.white),
                                          child: Text(
                                            'Reviews',
                                            style: TextStyle(
                                                color: isReviews
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontFamily: 'WorkSans',
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isReviews = false;
                                            isPhotos = true;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 700),
                                          curve: Curves.easeIn,
                                          padding: EdgeInsets.fromLTRB(
                                              7.0, 4.0, 7.0, 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              color: isPhotos
                                                  ? Colors.green.shade300
                                                  : Colors.white),
                                          child: Text(
                                            'Photos',
                                            style: TextStyle(
                                                color: isPhotos
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontFamily: 'WorkSans',
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 250.0,
                                  child: isReviews
                                      ? ListView(
                                          children: [
                                            if (isReviews &&
                                                tappedPlaceDetail['reviews'] !=
                                                    null)
                                              ...tappedPlaceDetail['reviews']!
                                                  .map((e) {
                                                return buildReviewItem(e);
                                              })
                                          ],
                                        )
                                      : buildPhotoGallery(
                                          tappedPlaceDetail['photos'] ?? []),
                                )
                              ],
                            ),
                          ),
                        ))
                    : Container()
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomLeft,
          fabColor: Color.fromARGB(255, 58, 26, 109),
          fabOpenColor: Color.fromARGB(255, 0, 4, 247),
          ringDiameter: 250.0,
          ringWidth: 40.0,
          ringColor: Color.fromARGB(255, 15, 22, 78),
          fabSize: 60.0,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.backpack,
                    color: Color.fromARGB(255, 15, 22, 78))),
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToggle = true;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                  });
                },
                icon: const Icon(Icons.search, color: Colors.white)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.backpack,
                    color: Color.fromARGB(255, 15, 22, 78))),
          ]),
    );
  }

  _nearbyPlacesList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 105.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          cardTapped = !cardTapped;
          if (cardTapped) {
            tappedPlaceDetail = await MapServices()
                .getPlace(allFavoritePlaces[index]['place_id']);
            setState(() {});
          }
          //  moveCameraSlightly();
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 100.0,
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 4.0),
                          blurRadius: 10.0)
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      _pageController.position.haveDimensions
                          ? _pageController.page!.toInt() == index
                              ? Container(
                                  height: 90.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(placeImg != ''
                                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                              : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  height: 90.0,
                                  width: 20.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                      color: Colors.blue),
                                )
                          : Container(),
                      SizedBox(width: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 170.0,
                            child: Text(allFavoritePlaces[index]['name'],
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold)),
                          ),
                          RatingStars(
                            value: allFavoritePlaces[index]['rating']
                                        .runtimeType ==
                                    int
                                ? allFavoritePlaces[index]['rating'] * 1.0
                                : allFavoritePlaces[index]['rating'] ?? 0.0,
                            starCount: 5,
                            starSize: 10,
                            valueLabelColor: const Color(0xff9b9b9b),
                            valueLabelTextStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            valueLabelRadius: 10,
                            maxValue: 5,
                            starSpacing: 2,
                            maxValueVisibility: false,
                            valueLabelVisibility: true,
                            animationDuration: Duration(milliseconds: 1000),
                            valueLabelPadding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 8),
                            valueLabelMargin: const EdgeInsets.only(right: 8),
                            starOffColor: const Color(0xffe7e8ea),
                            starColor: Colors.yellow,
                          ),
                          Container(
                            width: 170.0,
                            child: Text(
                              allFavoritePlaces[index]['business_status'] ??
                                  'none',
                              style: TextStyle(
                                  color: allFavoritePlaces[index]
                                              ['business_status'] ==
                                          'OPERATIONAL'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildReviewItem(review) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(review['profile_photo_url']),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: 4.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 160.0,
                  child: Text(
                    review['author_name'],
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 3.0),
                RatingStars(
                  value: review['rating'] * 1.0,
                  starCount: 5,
                  starSize: 7,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 9.0),
                  valueLabelRadius: 7,
                  maxValue: 5,
                  starSpacing: 2,
                  maxValueVisibility: false,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 1000),
                  valueLabelPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  valueLabelMargin: const EdgeInsets.only(right: 4),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.yellow,
                )
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              review['text'],
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Divider(color: Colors.grey.shade600, height: 1.0)
      ],
    );
  }

  buildPhotoGallery(photoElement) {
    if (photoElement == null || photoElement.length == 0) {
      showBlankCard = true;
      return Container(
        child: Center(
          child: Text(
            'No Photos',
            style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 12.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      var placeImg = photoElement[photoGalleryIndex]['photo_reference'];
      var maxWidth = photoElement[photoGalleryIndex]['width'];
      var maxHeight = photoElement[photoGalleryIndex]['height'];
      var tempDisplayIndex = photoGalleryIndex + 1;

      return Column(
        children: [
          SizedBox(height: 10.0),
          Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photo_reference=$placeImg&key=$key'),
                      fit: BoxFit.cover))),
          SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != 0)
                    photoGalleryIndex = photoGalleryIndex - 1;
                  else
                    photoGalleryIndex = 0;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != 0
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Prev',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Text(
              '$tempDisplayIndex/' + photoElement.length.toString(),
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != photoElement.length - 1)
                    photoGalleryIndex = photoGalleryIndex + 1;
                  else
                    photoGalleryIndex = photoElement.length - 1;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != photoElement.length - 1
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ])
        ],
      );
    }
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await controller1.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.green, size: 25.0),
            SizedBox(width: 4.0),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }
}
