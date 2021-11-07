import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool? _isConnectionSuccessful;

  @override
  initState() {
    super.initState();
    startTime();
    _tryConnection();
  }

  startTime() {
    var _duration = Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if(_isConnectionSuccessful == false){
      defaultTargetPlatform == TargetPlatform.iOS
      ?
      showCupertinoDialog(
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text('No Internet Access'),
            content: Text('Please Turn On Your Internet Access'),
            actions: [
              CupertinoDialogAction(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(SplashScreen.routeName);
                },
                child: Text('Retry'),
              ),
            ],
          );
        },
      )
      :
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('No Internet Access'),
            content: Text('Please Turn On Your Internet Access'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(SplashScreen.routeName);
                },
                child: Text('Retry'),
              ),
            ],
          );
        },
      );
    }else{
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
        print('Connected to a Wi-Fi network with inet access');
      });
    } on SocketException catch (e) {
      print(e);
      setState(() {
        _isConnectionSuccessful = false;
        print('Connected to a Wi-Fi network without inet access');
        print(_isConnectionSuccessful);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/splash.png'),
      ),
    );
  }
}