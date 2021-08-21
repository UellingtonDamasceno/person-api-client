import 'package:flutter/material.dart';
import 'package:person_api_client/src/views/pages/person_list/person_list.dart';
import 'package:person_api_client/src/views/pages/splash_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "People",
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => SplashScreen(),
        "/home": (context) => PersonList(),
      },
    );
  }
}
