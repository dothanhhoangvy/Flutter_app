import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testcapstone/components/bottomnavbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../NetworkHandler.dart';

const imgsupergraphic = "assets/supergraphic.svg";
const imglogo = "assets/boschsymbol.svg";
const imglogo1 = "assets/hcmutelogo.png";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPass = true;
  TextEditingController _userController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String? errorText;
  bool validate = false;
  bool circular = false;
  NetworkHandler networkHandler = NetworkHandler();
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0).r,
                child: SizedBox(
                  width: double.infinity,
                  height: 20.h,
                  child: SvgPicture.asset(
                    imgsupergraphic,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 30, 50).r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SvgPicture.asset(
                      imglogo,
                      width: 150.h,
                    ),
                    Image.asset(
                      imglogo1,
                      width: 50.h,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _userController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          errorText: validate ? null : errorText,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Enter Username";
                          }
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _passController,
                          obscureText: _showPass,
                          decoration: InputDecoration(
                            errorText: validate ? null : errorText,
                            labelText: "Password",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffix: InkWell(
                              onTap: () {
                                setState(() {
                                  _showPass = !_showPass;
                                });
                              },
                              child: Icon(
                                _showPass
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            } else if (_passController.text.length < 8) {
                              return "Password length should be more 8 chareacters";
                            }
                          })),
                      const SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () async {
                          {
                            setState(() {
                              circular = true;
                            });
                            //Login Logic start here
                            Map<String, String> data = {
                              "username": _userController.text,
                              "password": _passController.text,
                            };
                            var response =
                                await networkHandler.post("/users/login", data);
                            if (_passController.text.length > 8) {
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                final output = jsonDecode(response.body);
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                await pref.setString(
                                    "login", _userController.text);
                                await storage.write(
                                    key: "token", value: output["token"]);
                                setState(() {
                                  validate = true;
                                  circular = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainPage(),
                                    ),
                                    (route) => false);
                              } else {
                                setState(() {
                                  validate = false;
                                  errorText = "Wrong Username or Password";
                                  circular = false;
                                });
                              }
                            } // login logic End here
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: circular
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Log In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     TextButton(
                      //       onPressed: () {},
                      //       child: Text(
                      //         "Changing password?",
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
