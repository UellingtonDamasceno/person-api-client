import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:person_api_client/src/mappers/person_mapper.dart';
import 'package:person_api_client/src/models/person.dart';
import 'package:person_api_client/src/repositories/person_repository.dart';

import '../../mappers/person_mapper.dart';
import '../../mappers/phone_mapper.dart';
import '../../repositories/person_repository.dart';

class PersonList extends StatefulWidget {
  const PersonList({Key? key}) : super(key: key);

  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  var _repository;
  late Future<List<Person>> _people;

  @override
  void initState() {
    var options = BaseOptions(
      baseUrl: 'https://my-person-api.herokuapp.com/api/v1',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );

    Dio client = Dio(options);
    PersonMapper personMapper = PersonMapper(PhoneMapper());

    _repository = PersonRepository(personMapper, client);
    _people = _repository.findAll();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Peoples"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _people = _repository.findAll();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: _people,
          builder: (var context, AsyncSnapshot<List<Person>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Icon(Icons.info),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var person = snapshot.data![index];
                  return Dismissible(
                    key: Key("$person.id"),
                    onDismissed: (direction) {
                      Person person = snapshot.data!.elementAt(index);
                      if (direction == DismissDirection.startToEnd) {
                        print("praca");
                      } else {
                        _showDeleteDialogConfirmation(snapshot, person);
                      }
                    },
                    child: ListTile(
                      title: Text(person.firstName + ' ' + person.lastName),
                      subtitle: Text(person.cpf),
                      trailing: Icon(Icons.plus_one),
                    ),
                    background: Container(
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.edit),
                      color: Colors.blue,
                    ),
                    secondaryBackground: Container(
                      padding: EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.person_remove),
                      color: Colors.red,
                    ),
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          height: 50,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _showDeleteDialogConfirmation(
      AsyncSnapshot<List<Person>> people, Person person) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Tem certeza que deseja apagar'),
                Text('$person?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                people.data!.add(person);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Sim',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$person Deleted sucessful!'),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
