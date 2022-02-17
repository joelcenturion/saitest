/*
Using webview_flutter 1.0.7
https://pub.dev/packages/webview_flutter
*/
import 'dart:convert';
import 'dart:io';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview6Page extends StatefulWidget {
  @override
  _Webview6PageState createState() => _Webview6PageState();
}

class _Webview6PageState extends State<Webview6Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  late WebViewController _controller;

  final String htmlString = '''
<html>
<head>
    <title>Communicate from Webview to Flutter</title>
</head>
<body>
<div>Communicate from Webview to Flutter</div>
<br><br>
<button onclick="sendBack();">Click Me</button>
<script type="text/javascript">
    function sendBack() {
        messageHandler.postMessage("Hello from JS");
    }
</script>
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
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'messageHandler',
              onMessageReceived: (JavascriptMessage message) {
                Fluttertoast.showToast(msg: 'message : '+message.message, toastLength: Toast.LENGTH_SHORT);
              })
        ]),
      ),
    );
  }

  _loadHtmlFromTextString() async {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(htmlString));
    await _controller.loadUrl('data:text/html;base64,$contentBase64');
  }
}
