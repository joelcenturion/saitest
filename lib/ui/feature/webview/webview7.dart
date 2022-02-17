/*
Using webview_flutter 1.0.7
https://pub.dev/packages/webview_flutter
*/
import 'dart:io';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview7Page extends StatefulWidget {
  @override
  _Webview7PageState createState() => _Webview7PageState();
}

class _Webview7PageState extends State<Webview7Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  late WebViewController _controller;

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
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _globalWidget.globalAppBar(),
        body: WebView(
          initialUrl: 'https://devkit.ijteknologi.com/',
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          onWebViewCreated: (WebViewController webviewController) {
            _controller = webviewController;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
