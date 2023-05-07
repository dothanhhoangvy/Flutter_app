import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testcapstone/components/login.dart';

import 'components/bottomnavbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checklogin();
  }

  void checklogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString("login");
    print(val);
    await Future.delayed(Duration(seconds: 4), () {
      if (val != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false);
      }
    });
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
      body: Container(
        alignment: Alignment.center,
        color: const Color.fromARGB(31, 126, 126, 126),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 200.w,
                height: 200.h,
                decoration:
                    const BoxDecoration(borderRadius: BorderRadius.zero),
                child: const Image(
                  image: AssetImage("assets/splscreen.gif"),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0).r,
              child: Container(
                margin: EdgeInsets.only(left: 12.w),
                child: Text(
                  "Loading...",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
