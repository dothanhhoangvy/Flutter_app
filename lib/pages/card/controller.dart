import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool isShowTyre = false;

  void showTyreController(int index) {
    // Once user on this tyre tab we want to show the tyre
    // let's define this method on bottom navigation
    if (index == 0) {
      // Because we call this method before [onBottomNavigationTabChange]
      // as you can see we want to show those tyres a little bit later
      // Now  when the car on center after that we set isShowTyre = true
      Future.delayed(
        const Duration(milliseconds: 400),
        () {
          isShowTyre = true;
          notifyListeners();
        },
      );
    } else {
      isShowTyre = false;
      notifyListeners();
    }
  }

  bool isShowTyreStatus = false;

  void tyreStatusController(int index) {
    if (index == 0) {
      isShowTyreStatus = true;
      notifyListeners();
    } else {
      Future.delayed(const Duration(milliseconds: 400), () {
        isShowTyreStatus = false;
        notifyListeners();
      });
    }
  }
}
