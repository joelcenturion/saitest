import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class PaddingWidgetPage extends StatefulWidget {
  @override
  _PaddingWidgetPageState createState() => _PaddingWidgetPageState();
}

class _PaddingWidgetPageState extends State<PaddingWidgetPage> {
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
                child: Text('Padding Widget', style: TextStyle(
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
                          child: Text('Padding Widget used to give padding to widget that doesn\'t have padding', style: TextStyle(
                              fontSize: 15, color: BLACK77,letterSpacing: 0.5
                          )),
                        )
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.padding, size: 50, color: SOFT_BLUE))
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
                  child: Text('Without padding')
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    child: Text('This card is without padding widget'),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('With padding')
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('This card is wrapped by padding widget')
                    ),
                  )
              ),
            ],
          ),
        )
    );
  }
}
