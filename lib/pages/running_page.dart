import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../pages/info_page.dart';
import '../pages/registration_page.dart';
import '../pages/map_screen.dart';

class RunningPage extends StatefulWidget {
  @override
  _RunningPageState createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  List<Map<String, Object>> _pages;

  int _selectPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {
        'page': InformationPage(),
        'title': 'Information',
      },
      {
        'page': MapScreen(
          runningType: 'Percursos',
          isFamily: false,
        ),
        'title': 'Percursos',
      },
      {
        'page': RegistrationPage(),
        'title': 'Registo',
      },
    ];
    super.initState();
  }

  Widget _buildIosHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              title: Text('Informação'), icon: Icon(CupertinoIcons.info)),
          BottomNavigationBarItem(
              title: Text('Percurso'), icon: Icon(Icons.map)),
          BottomNavigationBarItem(
              title: Text('Registo'), icon: Icon(Icons.directions_run)),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: 'Informação',
              builder: (context) => InformationPage(),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: 'Percursos',
              builder: (context) => MapScreen(
                runningType: 'Percursos',
                isFamily: false,
              ),
            );
          case 2:
            return CupertinoTabView(
              defaultTitle: 'Registo',
              builder: (context) => RegistrationPage(),
            );
          default:
            assert(false, 'Unexpected tab');
            return null;
        }
      },
    );
  }

  Widget _buildAndroidHomePage(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _selectPage,
        currentIndex: _selectPageIndex,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
            ),
            title: Text('Informação'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
            ),
            title: Text('Percursos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.directions_run,
            ),
            title: Text('Registo'),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: _pages[_selectPageIndex]['page'],
    );
  }

  WidgetBuilder androidBuilder;
  WidgetBuilder iosBuilder;

  @override
  Widget build(BuildContext context) {
    androidBuilder = _buildAndroidHomePage;
    iosBuilder = _buildIosHomePage;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iosBuilder(context);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return null;
    }
  }
}
