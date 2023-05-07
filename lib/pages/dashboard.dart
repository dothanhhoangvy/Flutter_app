import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testcapstone/components/logout.dart';
import 'package:testcapstone/dashboard/maindashboard.dart';
// import 'package:testcapstone/components/bodydashboard.dart';

import '../components/drawer.dart';

const imgLogout = "assets/logout.svg";
const imgMenu = "assets/list-view-mobile.svg";

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        yesCancelDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "DASHBOARD",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
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
                height: 24,
                color: Colors.black,
              ),
            )
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: SizedBox(
                height: 10,
                width: double.infinity,
                child: SvgPicture.asset(
                  imgTabbar,
                  fit: BoxFit.cover,
                ),
              )),
        ),
        body: const MainDashboard(),
      ),
    );
  }
}
