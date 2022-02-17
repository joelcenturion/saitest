import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GestureDetectorWidgetPage extends StatefulWidget {
  @override
  _GestureDetectorWidgetPageState createState() => _GestureDetectorWidgetPageState();
}

class _GestureDetectorWidgetPageState extends State<GestureDetectorWidgetPage> {
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
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text('Gesture Detector Widget', style: TextStyle(
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
                          child: Text('Gesture Detector Widget used to handle touch on object.', style: TextStyle(
                              fontSize: 15, color: BLACK77,letterSpacing: 0.5
                          )),
                        )
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.touch_app, size: 50, color: SOFT_BLUE))
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
                  margin: EdgeInsets.only(top: 10),
                  child: Text('On single tap')
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: (){
                    Fluttertoast.showToast(msg: 'Tapped once', toastLength: Toast.LENGTH_SHORT);
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text('Tap me once')
                    ),
                  ),
                ),
              ),
              Divider(),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('On single tap without behaviour, you only can hit the text or icon')
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: (){
                    Fluttertoast.showToast(msg: 'Pressed 1', toastLength: Toast.LENGTH_SHORT);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Menu Title', style: TextStyle(
                          fontSize: 15,
                        )),
                        Icon(Icons.chevron_right, size: 20, color: SOFT_GREY),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('On single tap with behaviour, you can hit all entire container')
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    Fluttertoast.showToast(msg: 'Pressed 2', toastLength: Toast.LENGTH_SHORT);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Menu Title', style: TextStyle(
                          fontSize: 15,
                        )),
                        Icon(Icons.chevron_right, size: 20, color: SOFT_GREY),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('On double tap')
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onDoubleTap: (){
                    Fluttertoast.showToast(msg: 'Tapped double', toastLength: Toast.LENGTH_SHORT);
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Tap me twice')
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('On long press')
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onLongPress: (){
                    Fluttertoast.showToast(msg: 'Long press', toastLength: Toast.LENGTH_SHORT);
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Long press me')
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
