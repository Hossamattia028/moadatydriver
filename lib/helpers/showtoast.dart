import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
var color = const Color(0xff0f202A);
var colorred = const Color(0xfff62727);
var coloryellow = const Color(0xfff9b000);



void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

