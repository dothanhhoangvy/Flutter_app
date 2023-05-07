import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:location/location.dart';


class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  List<String> images = [
    'assets/car.png',
    "assets/fueliconmap.png",
    "assets/fueliconmap.png",
    "assets/fueliconmap.png",
    "assets/fueliconmap.png",
    "assets/fueliconmap.png",
  ];

  Uint8List? markerImage;
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final Set<Polyline> _polyline = {};
  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latlng = [
    const LatLng(10.802009060080623, 106.63971761965523),
    const LatLng(10.802693572453357, 106.63872871456745),
    const LatLng(10.802780541003678, 106.63600184140826),
    const LatLng(10.806750840942286, 106.635188009752),
    const LatLng(10.801642324730492, 106.64843453253307),
    const LatLng(10.798738863391975, 106.64210105206318),
  ];

  final List<LatLng> _polylinelatlng4 = [
    const LatLng(10.801977799897895, 106.64002051676897),
    const LatLng(10.802256417423685, 106.64004130388749),
    const LatLng(10.802202406481435, 106.64046174012341),
    const LatLng(10.802434794052123, 106.64043364301445),
    const LatLng(10.802172621858073, 106.64370599172584),
    const LatLng(10.80203437766931, 106.64525551207143),
    const LatLng(10.801985224819036, 106.64558735565446),
    const LatLng(10.801751196153477, 106.64844323919442),
  ];

  final List<LatLng> _polylinelatlng2 = [
    const LatLng(10.80197895053519, 106.64001478509584),
    const LatLng(10.802255083648843, 106.64004211565822),
    const LatLng(10.802209061480868, 106.64045597845978),
    const LatLng(10.80243150189407, 106.64043645662952),
    const LatLng(10.802353774281439, 106.64147244482773),
    const LatLng(10.80217264004428, 106.64163337735825),
    const LatLng(10.80098501581895, 106.64146982252242),
    const LatLng(10.800615119054756, 106.64139673864709),
    const LatLng(10.800384142942429, 106.64144275033372),
    const LatLng(10.800106613494142, 106.64157374342503),
    const LatLng(10.799479102279848, 106.64119418406113),
    const LatLng(10.79992064735064, 106.6403078963638),
    const LatLng(10.801859116299577, 106.63677793019762),
    const LatLng(10.802249439982353, 106.63646272596212),
    const LatLng(10.802919259708084, 106.63612949350217),
    const LatLng(10.80288698494915, 106.63604969778915),
    const LatLng(10.802590461374852, 106.63620036380338),
  ];

  final List<LatLng> _polylinelatlng1 = [
    const LatLng(10.801977580387575, 106.64002042500056),
    const LatLng(10.80225619791357, 106.64004389432793),
    const LatLng(10.80220318930707, 106.64046451761311),
    const LatLng(10.80243466206945, 106.64043590392345),
    const LatLng(10.802346365882096, 106.6416229006254),//
    const LatLng(10.802466358129054, 106.64157910851549),
    const LatLng(10.802606650741591, 106.63991232400312),
    const LatLng(10.802846756399077, 106.63900580623796),
    const LatLng(10.803126490216217, 106.63851802283146),
    const LatLng(10.803337693497268, 106.63826626251978),
    const LatLng(10.804237580347811, 106.63763310668627),
    const LatLng(10.804223962063489, 106.63750833027281),
    const LatLng(10.803264086933918, 106.63817224815806),
    const LatLng(10.802831239275992, 106.63879102929191),
  ];

  final List<LatLng> _polylinelatlng3 = [
    const LatLng(10.80197895053519, 106.64001478509584),
    const LatLng(10.802255083648843, 106.64004211565822),
    const LatLng(10.802209061480868, 106.64045597845978),
    const LatLng(10.80243150189407, 106.64043645662952),
    const LatLng(10.802353774281439, 106.64147244482773),
    const LatLng(10.80217264004428, 106.64163337735825),
    const LatLng(10.800980811681063, 106.64146496954004),
    const LatLng(10.800611160048044, 106.6414010200375),
    const LatLng(10.800108626379366, 106.64157319177507),
    const LatLng(10.799480458111137, 106.64118949475993),
    const LatLng(10.80185934836768, 106.63677480688403),//
    const LatLng(10.802136932238477, 106.63654405443502),
    const LatLng(10.806640362675902, 106.63495749075413),
    const LatLng(10.80683965003918, 106.63508526544418),
  ];

  final List<LatLng> _polylinelatlng5 = [
    const LatLng(10.80197895053519, 106.64001478509584),
    const LatLng(10.802255083648843, 106.64004211565822),
    const LatLng(10.802209061480868, 106.64045597845978),
    const LatLng(10.80243150189407, 106.64043645662952),
    const LatLng(10.802353774281439, 106.64147244482773),
    const LatLng(10.80217264004428, 106.64163337735825),
    const LatLng(10.800983294977652, 106.64146985413429),
    const LatLng(10.800620924344555, 106.64139868256979),
    const LatLng(10.80010941007408, 106.6415706805064),
    const LatLng(10.799409303381768, 106.6411519671024),
    const LatLng(10.79884160539651, 106.6421563932299),//
  ];

  final List<String> _title = [
    "Hoang Vy is here",
    "KK OIL CHXD XUÂN VINH",
    "Cửa hàng xăng dầu số 25 - công ty cổ phần nhiên liệu sài gòn",
    "Đại Lý Xăng Dầu An Khang",
    "Cây xăng Cộng Hoà",
    "Trạm Xăng Dầu Số 17",
  ];
  final List<String> _snippet = [
    "HVy is working here",
    "366 Cộng Hòa, Phường 13, Tân Bình, Thành phố Hồ Chí Minh, Việt Nam",
    "599 Trường Chinh, Tân Sơn Nhì, Tân Phú, Thành phố Hồ Chí Minh, Việt Nam",
    "29 Trường Chinh, Phường 15, Tân Bình, Thành phố Hồ Chí Minh, Việt Nam",
    "19A Cộng Hòa, Phường 12, Tân Bình, Thành phố Hồ Chí Minh, Việt Nam",
    "401 Trường Chinh, Phường 14, Tân Bình, Thành phố Hồ Chí Minh, Việt Nam",
  ];

  // GoogleMapPolyline polyline1 =
  //     new GoogleMapPolyline(apiKey: "AIzaSyClaN_8FhjzZnq9B7jHLO5DVZkSWxKWMoo");

  // final List
  final Set<Marker> _markersdefault = HashSet<Marker>();
  final Set<Circle> _circles = HashSet<Circle>();
  final Completer<GoogleMapController> _mapController = Completer();

  //direction
  final Set<Polyline> _polylines = {};
  // late List<LatLng> routeCoords;
  // GoogleMapPolyline googleMapPolyline =
  //   new GoogleMapPolyline(apiKey: "yourkeyhere");
  // late BitmapDescriptor _markerIcon;
  bool _showfuelstation = true;
  bool _showdirection1 =false; 
  bool _showdirection2 =false; 
  bool _showdirection3 =false; 
  bool _showdirection4 =false; 
  bool _showdirection5 =false; 

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _setMarkerIcon();
    _setMarkerdefault();
    _setMarker1();
    _setCircles();
    _getLocationPermission();
    _setPolylines4();
    _setPolylines1();
    _setPolylines2();
    _setPolylines3();
    _setPolylines5();
  }

  void _getLocationPermission() async {
    var location = Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location access');
    }
  }

  void _setPolylines1() async {
    if (_showdirection1 == true) {
      Polyline polylines = Polyline(
        polylineId: const PolylineId("Direction"),
        points: _polylinelatlng1,
        color: Colors.blue,
        width: 5
      );
      _polyline.add(polylines);
    } else {
      _polyline.clear();
    }
    setState(() {});
  }

    void _setPolylines2() async {
    if (_showdirection2 == true) {
      Polyline polylines = Polyline(
        polylineId: const PolylineId("Direction"),
        points: _polylinelatlng2,
        color: Colors.blue,
        width: 5
      );
      _polyline.add(polylines);
    } else {
      _polyline.clear();
    }
    setState(() {});
  }

    void _setPolylines3() async {
    if (_showdirection3 == true) {
      Polyline polylines = Polyline(
        polylineId: const PolylineId("Direction"),
        points: _polylinelatlng3,
        color: Colors.blue,
        width: 5
      );
      _polyline.add(polylines);
    } else {
      _polyline.clear();
    }
    setState(() {});
  }

  void _setPolylines4() async {
    if (_showdirection4 == true) {
      Polyline polylines = Polyline(
        polylineId: const PolylineId("Direction"),
        points: _polylinelatlng4,
        color: Colors.blue,
        width: 5
      );
      _polyline.add(polylines);
    } else {
      _polyline.clear();
    }
    setState(() {});
  }

  void _setPolylines5() async {
    if (_showdirection5 == true) {
      Polyline polylines = Polyline(
        polylineId: const PolylineId("Direction"),
        points: _polylinelatlng5,
        color: Colors.blue,
        width: 5
      );
      _polyline.add(polylines);
    } else {
      _polyline.clear();
    }
    setState(() {});
  }

  void _setMarkerdefault() async {
    _markersdefault.add(const Marker(
      markerId: MarkerId("Origin"),
      position: LatLng(10.802009060080623, 106.63971761965523),
      infoWindow: InfoWindow(
        title: "Hoang Vy is here",
        snippet: "HVy is working here",
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    setState(() {});
  }

  _setMarker1() async {
    for (int i = 0; i < _latlng.length; i++) {
      final Uint8List _markerIcon =
          await getBytesFromAsset(images[i].toString(), 100);
      if (i == 0) {
        _markers.add(
          Marker(
              markerId: MarkerId(i.toString()),
              position: _latlng[i],
              infoWindow: const InfoWindow(
                title: "Hoang Vy is here",
                snippet: "Hoang Vy is working here",
              ),
              icon: BitmapDescriptor.fromBytes(_markerIcon)),
        );
      } else if (i==4){
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            infoWindow: InfoWindow(
              title: _title[i],
              snippet: _snippet[i],
              onTap: () {
                _showdirection4 = !_showdirection4;
                _showdirection1 = false;
                _showfuelstation = false;
                _showdirection2 = false;
                _showdirection3 = false;
                _showdirection5 = false;
                _setPolylines4();
              },
            ),
            icon: BitmapDescriptor.fromBytes(_markerIcon)));
      }else if (i==1){
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            infoWindow: InfoWindow(
              title: _title[i],
              snippet: _snippet[i],
              onTap: () {
                _showdirection1 = !_showdirection1;
                _showdirection4 = false;
                _showdirection2 = false;
                _showdirection3 = false;
                _showdirection5 = false;
                _showfuelstation = false;
                _setPolylines1();
              },
            ),
            icon: BitmapDescriptor.fromBytes(_markerIcon)));
      }else if (i==2){
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            infoWindow: InfoWindow(
              title: _title[i],
              snippet: _snippet[i],
              onTap: () {
                _showdirection2 = !_showdirection2;
                _showdirection4 = false;
                _showdirection1 = false;
                _showdirection3 = false;
                _showdirection5 = false;
                _showfuelstation = false;
                _setPolylines2();
              },
            ),
            icon: BitmapDescriptor.fromBytes(_markerIcon)));
      }else if (i==3){
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            infoWindow: InfoWindow(
              title: _title[i],
              snippet: _snippet[i],
              onTap: () {
                _showdirection3 = !_showdirection3;
                _showdirection4 = false;
                _showdirection1 = false;
                _showdirection2 = false;
                _showdirection5 = false;
                _showfuelstation = false;
                _setPolylines3();
              },
            ),
            icon: BitmapDescriptor.fromBytes(_markerIcon)));
      }
      else if (i==5){
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            infoWindow: InfoWindow(
              title: _title[i],
              snippet: _snippet[i],
              onTap: () {
                _showdirection5 = !_showdirection5;
                _showdirection4 = false;
                _showdirection3 = false;
                _showdirection1 = false;
                _showdirection2 = false;
                _showfuelstation = false;
                _setPolylines5();
              },
            ),
            icon: BitmapDescriptor.fromBytes(_markerIcon)));
      }
      // else {
      //   _markers.add(Marker(
      //       markerId: MarkerId(i.toString()),
      //       position: _latlng[i],
      //       infoWindow: InfoWindow(
      //         title: _title[i],
      //         snippet: _snippet[i],
      //       ),
      //       icon: BitmapDescriptor.fromBytes(_markerIcon)));
      // }
      // setState(() {});
    }
  }

  void _setCircles() {
    _circles.add(
      const Circle(
          circleId: CircleId("0"),
          center: LatLng(10.802009060080623, 106.63971761965523),
          radius: 1000,
          strokeWidth: 2,
          fillColor: ui.Color.fromRGBO(211, 178, 244, 0.498)),
    );
  }

  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HawkFabMenu(
        icon: AnimatedIcons.menu_arrow,
        fabColor: Colors.white,
        iconColor: Colors.black,
        hawkFabMenuController: hawkFabMenuController,
        items: [
          HawkFabMenuItem(
            label: 'Current Location',
            ontap: () async {
                              _showfuelstation = true;
                _showdirection1 = false;
                _showdirection2 = false;
                _showdirection3 = false;
                _showdirection4 = false;
                _showdirection5 = false;
                   _setPolylines4();
    _setPolylines1();
    _setPolylines2();
    _setPolylines3();
    _setPolylines5();
              GoogleMapController controller = await _mapController.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                const CameraPosition(
                  target: LatLng(10.802009060080623, 106.63971761965523),
                  zoom: 14,
                ),
              ));
              setState(() {});
            },
            icon: const Icon(Icons.my_location),
            labelColor: Colors.white,
            labelBackgroundColor: Colors.blue,
          ),
          // HawkFabMenuItem(
          //   label: 'Direction To Gas Station',
          //   ontap: () async {
          //     setState(() {
          //       _showdirection = !_showdirection;
          //       _showfuelstation = false;
          //       _setPolylines();

          //     });
          //     // var direction = await DirectionService().getDirection(
          //     //   "10.802009060080623, 106.63971761965523",
          //     //   "10.801751196153477, 106.64844323919442"
          //     // );
          //     // direction['start_location']['10.802009060080623'];
          //     // direction['end_location']['106.63971761965523'];
          //     // _setPolylines(direction['polyline_decoded']);
          //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       _showdirection
          //           ? const SnackBar(content: Text('Direction To Gas Station'))
          //           : const SnackBar(
          //               content: Text('Cancel Direction To Gas Station')),
          //     );
          //   },
          //   icon: const Icon(Icons.navigation),
          //   color: Colors.yellow,
          //   labelColor: Colors.white,
          //   labelBackgroundColor: Colors.yellow,
          // ),
          HawkFabMenuItem(
            label: 'Search Gas Station',
            ontap: () async {
              setState(() {
                _showfuelstation = false;
              });
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search Gas Station')),
              );
            },
            icon: const Icon(Icons.local_gas_station),
            color: Colors.red,
            labelColor: Colors.white,
            labelBackgroundColor: Colors.red,
          ),
        ],
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: GoogleMap(
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(10.802009060080623, 106.63971761965523),
                  zoom: 14,
                ),
                markers: _showfuelstation
                    ? _markersdefault
                    : Set<Marker>.of(_markers),
                circles: _circles,
                myLocationEnabled: false,
                polylines: _polyline,
                myLocationButtonEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
