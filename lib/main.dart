import 'package:flutter/material.dart';
import 'package:pneumonia/intro.dart';
import 'package:pneumonia/home.dart';
import 'package:pneumonia/about.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Intro(),
      '/home': (context) => Home(),
      '/about': (context) => About(),
    },
  ));
}
