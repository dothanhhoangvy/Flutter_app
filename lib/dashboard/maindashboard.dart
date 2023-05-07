import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testcapstone/dashboard/gridcard.dart';
import 'package:testcapstone/dashboard/pages/fuel.dart';
import 'package:testcapstone/dashboard/pages/mil.dart';
import 'package:testcapstone/dashboard/pages/speed.dart';
import 'package:testcapstone/dashboard/pages/temp.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: GridView.count(
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
        crossAxisCount: 1,
        children: <Widget>[
          CategoryCard(
            title: "Engine Speed",
            svgSrc: "assets/speedometer-remove-background.gif",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SpeedPara();
                }),
              );
            },
          ),
          CategoryCard(
            title: "Engine Temperature",
            svgSrc: "assets/temperature.gif",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const TempPara();
                }),
              );
            },
          ),
          CategoryCard(
            title: "Mileage",
            svgSrc: "assets/mileage.gif",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const MileagePara();
                }),
              );
            },
          ),
          CategoryCard(
            title: "Fuel Level",
            svgSrc: "assets/gas.gif",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const FuelLvlPara();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
