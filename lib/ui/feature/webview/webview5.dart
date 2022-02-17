/*
Using webview_flutter 1.0.7
https://pub.dev/packages/webview_flutter
*/
import 'dart:convert';
import 'dart:io';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview5Page extends StatefulWidget {
  @override
  _Webview5PageState createState() => _Webview5PageState();
}

class _Webview5PageState extends State<Webview5Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  late WebViewController _controller;

  final String htmlString = '''
<html>
<head>
    <title>Communicate from Flutter to Webview</title>
</head>
<body>
<div>Communicate from Flutter to Webview</div>
<div id="text-change">This text will change if you pressed the FAB Button</div>
<script type="text/javascript">
    function communicateFromFlutter(newstring) {
        document.getElementById("text-change").innerHTML = newstring;
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          _controller.evaluateJavascript('communicateFromFlutter("Hiii, this text is <strong>changed</strong>")');
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
