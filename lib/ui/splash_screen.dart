/*
This is splash screen page
Don't forget to add all images and sound used in this pages at the pubspec.yaml
 */

import 'dart:async';
import 'dart:io';

import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/screen/signin/signin2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}
class _SplashScreenPageState extends State<SplashScreenPage> {
  Timer? _timer;
  int _second = 3; // set timer for 3 second and then direct to next page

  void _startTimer() {
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        _second--;
      });
      if (_second == 0) {
        _cancelFlashsaleTimer();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Signin2Page()), (Route<dynamic> route) => false);
      }
    });
  }

  void _cancelFlashsaleTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    // set status bar color to transparent and navigation bottom color to black21
    SystemChrome.setSystemUIOverlayStyle(
      Platform.isIOS?SystemUiOverlayStyle.light:SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: BLACK21,
          systemNavigationBarIconBrightness: Brightness.light
      ),
    );

    if(_second != 0){
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _cancelFlashsaleTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Container(
          color: Color(0xFFF1F3F6),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Center(
                        child: Image.asset('assets/images/logo_sai_app.png', height: 240)
                      ),
                      Center(
                        child: Text(
                          'S.A.I',
                          style: GoogleFonts.nunito(
                            fontSize:40,
                            fontWeight:FontWeight.w900,
                            color: Color(0xFF3D6670),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'APPLICATION',
                          style: GoogleFonts.nunito(
                            fontSize:18,
                            fontWeight:FontWeight.w500,
                            color: Color(0xFF3D6670),
                            letterSpacing: 9,
                          ),
                        ),
                      ),
                    ]
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 220,
                        ),
                        Center(
                          child: Text(
                            '2021. Todos los derechos reservados',
                            style: GoogleFonts.nunito(
                              fontSize:14,
                              fontWeight:FontWeight.w600,
                              color: Color(0xFF3D6670),
                            ),
                          ),
                        )
                      ]
                  )
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}
