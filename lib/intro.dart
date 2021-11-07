import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  void gonext() async {
    await Future.delayed(Duration(seconds: 3), () {
      print('splash');
    });
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    gonext();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SpinKitRotatingCircle(
        color: Colors.white,
        size: 80.0,
      ),
    );
  }
}
