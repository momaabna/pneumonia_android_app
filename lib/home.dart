import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _width = 50;
  double _height = 50;
  Widget _img = Image(
    image: AssetImage('assets/lungs.png'),
    width: 30,
  );
  File _image;
  final picker = ImagePicker();
  Dio dio = new Dio();

  void animate() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      _img = Image.file(_image);
      _width = 250;
      _height = 250;
    });
  }

  void initState() {
    super.initState();

    //animate();
  }

  Future uploadFile() async {
    setState(() {
      _img = SpinKitRotatingCircle(
        color: Colors.white,
        size: 80.0,
      );
    });
    try {
      String filename = _image.path.split('/').last;
      FormData form = FormData.fromMap({
        'file': await MultipartFile.fromFile(_image.path,
            filename: filename, contentType: new MediaType('image', 'jpeg')),
        'type': 'image/jpeg'
      });
      Response response = await dio.post('http://192.168.1.33:5000/predict',
          data: form,
          options: Options(headers: {'accept': 'application/json'}));
      if (response.statusCode == 200) {
        print('hello');
        Map json1 = jsonDecode(response.toString());

        if (json1['predictions'][0] > 50.0) {
          setState(() {
            _img = new CircularPercentIndicator(
              radius: 200.0,
              lineWidth: 20,
              percent: json1['predictions'][0] / 100,
              center: new Text(
                "Rate: ${json1['predictions'][0]}% \n Result:Pneumonia",
                style: TextStyle(color: Colors.white),
              ),
              progressColor: Colors.red[300],
            );
          });
        } else {
          setState(() {
            _img = new CircularPercentIndicator(
              radius: 200.0,
              lineWidth: 20,
              percent: json1['predictions'][0] / 100,
              center: new Text(
                "Rate: ${json1['predictions'][0]}% \n Result:Healthy",
                style: TextStyle(color: Colors.white),
              ),
              progressColor: Colors.green[300],
            );
          });
        }
      }
      print(response.data);
    } catch (e) {}
  }

  void goabout() async {
    Navigator.pushNamed(context, '/about');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.done,
                size: 30,
              ),
              onPressed: () async {
                await uploadFile();
              }),
        ],
        backgroundColor: Colors.black,
        title: Image(
          image: AssetImage('assets/lungs.png'),
          width: 30,
        ),
        centerTitle: true, // FlutterLogo(),

        elevation: 0,
      ),
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.bounceOut,
          width: _width,
          height: _height,
          color: Colors.black,
          child: _img,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  goabout();
                },
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              SizedBox(),
              Icon(
                Icons.info,
                color: Colors.black,
                size: 30,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add_circle,
          color: Colors.black,
          size: 50,
        ),
        onPressed: () {
          animate();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
