import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testcapstone/components/bottomnavbar.dart';
import 'package:testcapstone/components/login.dart';

class Shared extends StatefulWidget {
  const Shared({super.key});

  @override
  State<Shared> createState() => _SharedState();
}

class _SharedState extends State<Shared> {
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    Timer(const Duration(seconds: 1), () {
      print(_sharedPreferences);
      if (_sharedPreferences.getString('username') == null &&
          _sharedPreferences.getString('ID') == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
