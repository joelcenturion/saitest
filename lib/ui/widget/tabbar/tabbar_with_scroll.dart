import 'package:flutter/material.dart';

class TabbarWithScrollPage extends StatefulWidget {
  @override
  _TabbarWithScrollPageState createState() => _TabbarWithScrollPageState();
}

class _TabbarWithScrollPageState extends State<TabbarWithScrollPage> {
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
    return DefaultTabController(
      length: 8,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "TabBar with Scroll",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(child: Text('Tab 2')),
                Tab(text: 'Tab 3'),
                Tab(text: 'Tab 4'),
                Tab(text: 'Tab 5'),
                Tab(text: 'Tab 6'),
                Tab(text: 'Tab 7'),
                Tab(text: 'Tab 8'),
              ],
              isScrollable: true,
            ),
            backgroundColor: Colors.pinkAccent,
          ),
          body: TabBarView(
            children: [
              Container(
                child: Center(
                  child: Text('Content 1'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Content 2'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Content 3'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Content 4'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Content 5'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Content 6'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Content 7'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Content 8'),
                ),
              ),
            ],
          )
      ),
    );
  }
}
