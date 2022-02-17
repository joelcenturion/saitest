import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/config/static.dart';
import 'package:devkitflutter/ui/feature/feature_tab.dart';
import 'package:devkitflutter/ui/integration/integration_tab.dart';
import 'package:devkitflutter/ui/integration/local_notification/notification_detail.dart';
import 'package:devkitflutter/ui/screen/screen_tab.dart';
import 'package:devkitflutter/ui/apps/apps_tab.dart';
import 'package:devkitflutter/ui/widget/widget_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabBar _tabBar;
  int _tabIndex = 0;
  late TabController _tabController;

  List<Tab> _tabBarList = [
    Tab( text: "Screen List"),
    Tab( text: "Widget List"),
    Tab( text: "Awesome Features"),
    Tab( text: "Integrations"),
    Tab( text: "Apps")
  ];

  List<Widget> _tabContentList = <Widget>[
    ScreenTabPage(),
    WidgetTabPage(),
    FeatureTabPage(),
    IntegrationTabPage(),
    AppsTabPage()
  ];

  // this function is used for exit the application, user must click back button two times
  DateTime? _currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null || now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press BACK again to Exit', toastLength: Toast.LENGTH_SHORT);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/icon');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
          //localNotifData.add(LocalNotificationModel(id: id, title: title, body: body, payload: payload));
          // display a dialog with the notification details, tap ok to go to another page
          showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title!),
              content: Text(body!),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDetailPage(payload: payload!)));
                  },
                )
              ],
            ),
          );
        }
    );
    final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS
    );
    await StaticVarMethod.flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      //localNotifData.add(LocalNotificationModel(payload: payload));
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      await Navigator.push(context, MaterialPageRoute<void>(builder: (context) => NotificationDetailPage(payload: payload!)));
    });
  }

  @override
  void initState() {
    // set navigation bar color to default color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFFF2F2F2),
          systemNavigationBarIconBrightness: Brightness.light
      ),
    );

    StaticVarMethod.flutterLocalNotificationsPlugin.cancelAll();
    // used for local notification on integration
    if(!StaticVarMethod.isInitLocalNotif){
      StaticVarMethod.isInitLocalNotif = true;
      _initLocalNotification();
    }

    _tabController = TabController(vsync: this, length: _tabBarList.length, initialIndex: _tabIndex);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: true,
          title: Image.asset('assets/images/logo_horizontal.png', height: 24),
          bottom: PreferredSize(
              child: Column(
                children: [
                  Theme(
                    data: ThemeData(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: _tabBar = TabBar(
                      controller: _tabController,
                      onTap: (position){
                        setState(() {
                          _tabIndex = position;
                        });
                        //print('idx : '+_tabIndex.toString());
                      },
                      isScrollable: true,
                      labelColor: BLACK21,
                      labelStyle: TextStyle(fontSize: 14),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 4,
                      indicatorColor: BLACK21,
                      unselectedLabelColor: SOFT_GREY,
                      labelPadding: EdgeInsets.symmetric(horizontal: 30.0),
                      tabs: _tabBarList,
                    ),
                  ),
                  Container(
                    color: Colors.grey[200],
                    height: 1.0,
                  )
                ],
              ),
              preferredSize: Size.fromHeight(_tabBar.preferredSize.height+1))
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
          length: _tabBarList.length,
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: _tabContentList.map((Widget content) {
              return content;
            }).toList(),
          ),
        ),
      ),
    );
  }
}
