import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testcapstone/components/logout.dart';

import '../NetworkOTA.dart';
import '../components/drawer.dart';
import '../data/dataprofile.dart';

const imgMenu = "assets/list-view-mobile.svg";
const imgLogout = "assets/logout.svg";

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  // NetworkOTA _networkOTA = NetworkOTA();
  // Autogenerated autogenerate = Autogenerated();
  var isConnected = false;
  @override
  void initState() {
    super.initState();
    startStreaming();
      //  fetchData();
  }

  // void fetchData() async {
  //   var response = await _networkOTA.get(
  //       "https://api.eu1.bosch-iot-rollouts.com/rest/v1/targets/HYUNDAI_SANTA_FE_1_0");
  //   setState(() {
  //     autogenerate = Autogenerated.fromJson(response);
  //     print(autogenerate);
  //   });
  // }
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
          "SOFTWARE VERSION",
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0).r,
        child: Padding(
          padding: const EdgeInsets.all(2.0).r,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8).w,
                ),
                child: ListTile(
                  title: Text(
                    "VIN",
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp),
                  ),
                  trailing: Text(
                    // autogenerate.controllerId!,
                    "KL1C9W146HN012007",
                    style: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8).w,
                ),
                child: ListTile(
                  title: Text(
                    "ECU",
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp),
                  ),
                  trailing: Text(
                    //autogenerate.name!,
                    "MD1CS012",
                    style: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8).w,
                ),
                child: ListTile(
                  title: Text(
                    "Firmware",
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp),
                  ),
                  trailing: Text(
                    //autogenerate.name!,
                    "Huyndai Santa Fe 2.0",
                    style: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8).w,
                ),
                child: ListTile(
                  title: Text(
                    "Lastest Update",
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp),
                  ),
                  trailing: Text(
                    // autogenerate.name!,
                    "25/05/2023",
                    style: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
