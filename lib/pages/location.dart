import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testcapstone/components/logout.dart';
import 'package:testcapstone/location/current_location.dart';

const imgMenu = "assets/list-view-mobile.svg";
const imgTabbar = "assets/supergraphic.svg";
const imgLogout = "assets/logout.svg";

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  @override
  void initState() {
    super.initState();
    startStreaming();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LOCATION",
          style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
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
          )
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
      body: const CurrentLocation(),
    );
  }
}
