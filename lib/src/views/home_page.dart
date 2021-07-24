import 'package:flutter/material.dart';
import 'package:person_api_client/src/views/pages/person_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PersonList(),
    );
  }
}
