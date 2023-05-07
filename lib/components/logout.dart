import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testcapstone/components/login.dart';

Future<void> yesCancelDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(
              "Are you sure?".toUpperCase(),
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            content: const Text("Do you want to log out?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    await pref.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false);
                  },
                  child: const Text("Yes"))
            ],
          ));
}
