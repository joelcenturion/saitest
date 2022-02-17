/*
Using webview_flutter 1.0.7
https://pub.dev/packages/webview_flutter
*/
import 'dart:convert';
import 'dart:io';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview4Page extends StatefulWidget {
  @override
  _Webview4PageState createState() => _Webview4PageState();
}

class _Webview4PageState extends State<Webview4Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  late WebViewController _controller;

  final String htmlString = '''
<html>
<head>
    <title>Webview from HTML String</title>
</head>
<body>
<div>This webview is loaded from HTML String</div>
<div><strong>This text is strong</strong></div>
<div><i>This text is italic</i></div>
<div style="color:red; font-size:20px;">This text is styling with inline css</div>
<div>
    <ol>
        <li>
            List 1
            <ul>
                <li>Sub List 1.1</li>
                <li>Sub List 1.2</li>
                <li>Sub List 1.3</li>
            </ul>
        </li>
        <li>List 2</li>
        <li>List 3</li>
        <li>List 4</li>
        <li>List 5</li>
    </ol>
</div>
</body>
</html>
''';

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
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webviewController) {
          _controller = webviewController;
          _loadHtmlFromTextString();
        },
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
      ),
    );
  }

  _loadHtmlFromTextString() async {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(htmlString));
    await _controller.loadUrl('data:text/html;base64,$contentBase64');
  }
}
