import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class PositionedWidgetPage extends StatefulWidget {
  @override
  _PositionedWidgetPageState createState() => _PositionedWidgetPageState();
}

class _PositionedWidgetPageState extends State<PositionedWidgetPage> {
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
                child: Text('Positioned Widget', style: TextStyle(
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
                          child: Text('Positioned Widget only used when it wrapped with Stack Widget', style: TextStyle(
                              fontSize: 15, color: BLACK77,letterSpacing: 0.5
                          )),
                        )
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.photo_size_select_small, size: 50, color: SOFT_BLUE))
                    ),
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
                  child: Text('Position the icon inside stack')
              ),
              Container(
                width: 400,
                height: 400,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 8),
                // this is the start of example
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Icon(Icons.email)
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Icon(Icons.directions_car)
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Icon(Icons.directions_boat)
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(Icons.motorcycle)
                    ),
                    Positioned(
                      top: 0,
                      left: 40,
                      bottom: 0,
                      child: Icon(Icons.sports_basketball)
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
