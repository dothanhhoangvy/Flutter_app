import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'dart:async';

import 'package:testcapstone/components/logout.dart';
import 'package:testcapstone/pages/card/gaugefuel.dart';
import 'package:testcapstone/pages/card/gaugeodo.dart';
import 'package:testcapstone/pages/card/gaugespeed.dart';
import 'package:testcapstone/pages/card/gaugetemp.dart';

import 'card/controller.dart';
import 'card/controller_color.dart';
import 'card/tyres.dart';

// import 'package:mqtt_client/mqtt_client.dart' as mqtt;

const imglogo12 = "assets/boschsymbol.svg";
const imgTabbar = "assets/supergraphic.svg";
const imgLogout = "assets/logout.svg";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _tyreAnimationController;
  // We want to animate each tyre one by one
  late Animation<double> _animationTyre1Psi;
  late Animation<double> _animationTyre2Psi;
  late Animation<double> _animationTyre3Psi;
  late Animation<double> _animationTyre4Psi;
  final HomeController _controller = HomeController();
  late List<Animation<double>> _tyreAnimations;

  // mqtt.MqttClient? client;
  // mqtt.MqttConnectionState? connectionState;
  late PageController _pageController;
  int _currentPage = 0;

  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;

  checkInternet() async {
    result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      isConnected = false;
      showDialogBox();
    }
    setState(() {});
  }

  showDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("No Internet"),
              content: const Text("Please check your internet connection"),
              actions: [
                TextButton(
                    child: const Text("Retry"),
                    onPressed: () {
                      Navigator.pop(context);
                      checkInternet();
                    }),
              ],
            ));
  }

  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();
    });
  }

  @override
  void initState() {
    super.initState();
    setupTyreAnimation();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
    print(_currentPage);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
    _tyreAnimationController.dispose();
  }

  final List page = [
    const GaugeSpeed(),
    const GaugeTemp(),
    const GaugeFuel(),
    const GaugeOdo(),
  ];

  void setupTyreAnimation() {
    _tyreAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animationTyre1Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: const Interval(0.34, 0.5));
    _animationTyre2Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: const Interval(0.5, 0.66));
    _animationTyre3Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: const Interval(0.66, 0.82));
    _animationTyre4Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: const Interval(0.82, 1));
    _tyreAnimations = [
      _animationTyre1Psi,
      _animationTyre2Psi,
      _animationTyre3Psi,
      _animationTyre4Psi,
    ];
    setState(() {
      if (_currentPage == 0)
        _tyreAnimationController.forward();
      else if (_currentPage != 3) _tyreAnimationController.reverse();

      _controller.showTyreController(_currentPage);
      _controller.tyreStatusController(_currentPage);
      // Make sure you call it before [onBottomNavigationTabChange]
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _tyreAnimationController,
        ]),
        builder: (context, _) {
          return WillPopScope(
              onWillPop: () {
                yesCancelDialog(context);
                return Future.value(false);
              },
              child: Scaffold(
                  appBar: AppBar(
                    title: SvgPicture.asset(
                      imglogo12,
                      height: 70.h,
                      width: 70.w,
                      fit: BoxFit.scaleDown,
                    ),
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    actions: <Widget>[
                      IconButton(
                        hoverColor: Colors.black,
                        tooltip: "Log Out",
                        onPressed: () {
                          yesCancelDialog(context);
                        },
                        icon: SvgPicture.asset(
                          imgLogout,
                          height: 24.h,
                          color: Colors.black,
                        ),
                      ),
                    ],
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(10.h),
                        child: SizedBox(
                          height: 10.h,
                          width: double.infinity,
                          child: SvgPicture.asset(
                            imgTabbar,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  body: SafeArea(
                    child: LayoutBuilder(builder: (context, constrains) {
                      return Stack(alignment: Alignment.center, children: [
                        // Let's fixed it
                        SizedBox(
                          height: constrains.maxHeight,
                          width: constrains.maxWidth,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.black),
                          ),
                        ),
                        // Nothing really chnage, let's fix that
                        Positioned(
                          left: constrains.maxWidth / 2 * 0.001,
                          height: constrains.maxHeight,
                          width: constrains.maxWidth,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: constrains.maxHeight * 0.1),
                            // child: SvgPicture.asset(
                            //   "assets/Car.svg",
                            //   width: double.infinity,
                            // ),
                          ),
                        ),
                        //if (_controller.isShowTyre) ...tyres(constrains),
                        if (_controller.isShowTyreStatus)
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GridView.builder(
                              itemCount: 4,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio:
                                    constrains.maxWidth / constrains.maxHeight,
                              ),
                              itemBuilder: (context, index) => ScaleTransition(
                                scale: _tyreAnimations[index],
                                child: page[index],
                              ),
                            ),
                          ),
                      ]);
                    }),
                  )));
        });
  }
}
