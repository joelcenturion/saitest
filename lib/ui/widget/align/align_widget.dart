import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class AlignWidgetPage extends StatefulWidget {
  @override
  _AlignWidgetPageState createState() => _AlignWidgetPageState();
}

class _AlignWidgetPageState extends State<AlignWidgetPage> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  @override
  void initState() {
    super.initState();
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
        body: ListView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
          children: [
            Container(
              child: Text('Align Widget', style: TextStyle(
                  fontSize: 18, color: BLACK21, fontWeight: FontWeight.w500
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Row(
                children: [
                  Flexible(
                      flex:5,
                      child: Container(
                        child: Text('Align Widget used to do some alignment.', style: TextStyle(
                            fontSize: 15, color: BLACK77,letterSpacing: 0.5
                        )),
                      )
                  ),
                  Flexible(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.text_format, size: 50, color: SOFT_BLUE))
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 48),
              child: Text('Example', style: TextStyle(
                  fontSize: 18, color: BLACK21, fontWeight: FontWeight.w500
              )),
            ),
            SizedBox(height: 18),
            Container(
                margin: EdgeInsets.only(top: 10, bottom: 8),
                child: Text('Align top left')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 8),
                child: Text('Align top center')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 8),
                child: Text('Align top right')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.topRight,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 8),
                child: Text('Align center left')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 8),
                child: Text('Align center')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.center,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 8),
                child: Text('Align center right')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 8),
                child: Text('Align bottom left')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 8),
                child: Text('Align bottom center')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 8),
                child: Text('Align bottom right')
            ),
            Container(
              height: 150,
              color: Colors.pinkAccent,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text('Text', style: TextStyle(
                    color: Colors.white
                )),
              ),
            ),
          ],
        )
    );
  }
}
