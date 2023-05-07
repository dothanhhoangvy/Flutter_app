import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testcapstone/pages/home.dart';
import 'package:testcapstone/pages/location.dart';
import 'package:testcapstone/pages/update.dart';

import '../pages/card/controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final HomeController _controller = HomeController();
  // StreamSubscription<ReceivedAction> notificationsActionStreamSubscription;
  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  int _currentIndex = 0;
  final List tabss = [
    const HomePage(),
    const LocationPage(),
    const UpdatePage()
  ];
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
        ]),
        builder: (context, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: tabss[_currentIndex],
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Colors.black12,
                color: Colors.white,
                animationDuration: const Duration(milliseconds: 400),
                onTap: (index) {
                  _currentIndex = index;
                  _controller.showTyreController(index);
                  _controller.tyreStatusController(index);
                },
                items: const <Widget>[
                  Icon(Icons.home_outlined, size: 30),
                  Icon(Icons.location_on_outlined, size: 30),
                  Icon(Icons.autorenew_outlined, size: 30),
                ],
              ));
        });
  }
}
