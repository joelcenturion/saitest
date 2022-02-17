/*
Using webview_flutter 1.0.7
https://pub.dev/packages/webview_flutter
*/
import 'dart:io';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview2Page extends StatefulWidget {
  @override
  _Webview2PageState createState() => _Webview2PageState();
}

class _Webview2PageState extends State<Webview2Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  @override
  void initState() {
    super.initState();

    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _globalWidget.globalAppBar(),
      body: WebView(
        initialUrl: 'https://devkit.ijteknologi.com/',
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
      ),
    );
  }
}
