import 'package:flutter/material.dart';

bool changeColor = false;
void ColorController(isColor) {
  if (isColor == true) {
    changeColor = true;
  } else {
    changeColor = false;
  }
}
