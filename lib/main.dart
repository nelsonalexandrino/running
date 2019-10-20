import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/running_page.dart';
import './pages/registration_page.dart';
import './providers/registration_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final absaRed = MaterialColor(
    0xFFBE0028,
    const <int, Color>{
      50: const Color(0xFFBE0028),
      100: const Color(0xFFBE0028),
      200: const Color(0xFFBE0028),
      300: const Color(0xFFBE0028),
      400: const Color(0xFFBE0028),
      500: const Color(0xFFBE0028),
      600: const Color(0xFFBE0028),
      700: const Color(0xFFBE0028),
      800: const Color(0xFFBE0028),
      900: const Color(0xFFBE0028),
    },
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Registrations(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Absa Maratona',
        theme: ThemeData(
          primarySwatch: absaRed,
          fontFamily: 'Brave',
          canvasColor: Colors.transparent,
        ),
        builder: (context, child) {
          return CupertinoTheme(
            data: CupertinoThemeData(primaryColor: absaRed),
            child: Material(
              child: child,
            ),
          );
        },
        home: RunningPage(),
        routes: {
          RegistrationPage.routeName: (context) => RegistrationPage(),
        },
      ),
    );
  }
}
