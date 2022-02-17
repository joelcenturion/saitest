import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/reusable/cache_image_network.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class ClipRRectWidgetPage extends StatefulWidget {
  @override
  _ClipRRectWidgetPageState createState() => _ClipRRectWidgetPageState();
}

class _ClipRRectWidgetPageState extends State<ClipRRectWidgetPage> {
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
                child: Text('ClipRRect Widget', style: TextStyle(
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
                          child: Text('A widget that clips its child using a rounded rectangle.', style: TextStyle(
                              fontSize: 15, color: BLACK77,letterSpacing: 0.5
                          )),
                        )
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.filter_center_focus, size: 50, color: SOFT_BLUE))
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
                  child: Text('ClipRRect on image')
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                // this is the start of example
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: buildCacheNetworkImage(url: GLOBAL_URL+'/assets/images/product/1.jpg', width: 200),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('ClipRRect on container')
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                // this is the start of example
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('ClipRRect on container with text')
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                // this is the start of example
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.pinkAccent,
                    child: Text('a b c a b c a b c a b c a b c a b c a b c a b c a b c '
                        'a c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c '
                        'a c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c '
                        'a c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c '
                        'a c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c '
                        'a c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c a b c '),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
