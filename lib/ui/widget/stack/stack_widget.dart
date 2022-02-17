import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class StackWidgetPage extends StatefulWidget {
  @override
  _StackWidgetPageState createState() => _StackWidgetPageState();
}

class _StackWidgetPageState extends State<StackWidgetPage> {
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
                child: Text('Stack Widget', style: TextStyle(
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
                          child: Text('Stack Widget used to stacking widget', style: TextStyle(
                              fontSize: 15, color: BLACK77,letterSpacing: 0.5
                          )),
                        )
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.layers, size: 50, color: SOFT_BLUE))
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
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    height: 250,
                    color: Colors.grey[100],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                  Positioned(
                    top: 25,
                    left: 25,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 50,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.green,
                    ),
                  ),
                  Positioned(
                    top: 75,
                    left: 75,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 100,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  Positioned(
                    top: 125,
                    left: 125,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.purpleAccent,
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 150,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
