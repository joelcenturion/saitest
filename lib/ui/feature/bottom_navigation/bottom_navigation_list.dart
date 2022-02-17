import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/feature/bottom_navigation/bottom_navigation1.dart';
import 'package:devkitflutter/ui/feature/bottom_navigation/bottom_navigation2.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class BottomNavigationListPage extends StatefulWidget {
  @override
  _BottomNavigationListPageState createState() => _BottomNavigationListPageState();
}

class _BottomNavigationListPageState extends State<BottomNavigationListPage> {
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
              child: Text('Bottom Navigation', style: TextStyle(
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
                        child: Text('Bottom navigation used to navigate between page using bottom navigation.', style: TextStyle(
                            fontSize: 15, color: BLACK77,letterSpacing: 0.5
                        )),
                      )
                  ),
                  Flexible(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.call_to_action, size: 50, color: SOFT_BLUE))
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 48),
              child: Text('List', style: TextStyle(
                  fontSize: 18, color: BLACK21, fontWeight: FontWeight.w500
              )),
            ),
            SizedBox(height: 18),
            _globalWidget.screenDetailList(context: context, title: 'Bottom Navigation 1', page: BottomNavigation1Page()),
            _globalWidget.screenDetailList(context: context, title: 'Bottom Navigation 2', page: BottomNavigation2Page()),
          ],
        )
    );
  }
}
