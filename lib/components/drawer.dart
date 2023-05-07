import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testcapstone/pages/dashboard.dart';
import 'package:testcapstone/pages/home.dart';
import 'package:testcapstone/pages/location.dart';
import 'package:testcapstone/pages/update.dart';

const imgMenu = "assets/list-view-mobile.svg";
const imgTabbar = "assets/supergraphic.svg";
const imgHome = "assets/home.svg";
const imgDashboard = "assets/dashboard.svg";
const imgLocation = "assets/location.svg";
const imgUpdate = "assets/update.svg";

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
      )),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );
  Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 0, 24).r,
      child: Wrap(runSpacing: 16, children: [
        ListTile(
          title: const Text("Home"),
          leading: const Icon(Icons.home_outlined),
          onTap: (() => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              )),
        ),
        ListTile(
          title: const Text("Dashboard"),
          leading: const Icon(Icons.speed_outlined),
          onTap: (() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DashboardPage()))),
        ),
        ListTile(
          title: const Text("Location"),
          leading: const Icon(Icons.location_on_outlined),
          onTap: (() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LocationPage()))),
        ),
        ListTile(
          title: const Text("Update"),
          leading: const Icon(Icons.autorenew_outlined),
          onTap: (() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const UpdatePage()))),
        ),
        // const Divider(color: Colors.black),
        // ListTile(
        //   title: const Text("Dashboard"),
        //   leading: const Icon(Icons.home_outlined),
        //   onTap: (() => Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => const HomePage()))),
        // ),
      ]));
}
