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
  var _people;
  @override
  void initState() {
    var options = BaseOptions(
      baseUrl: 'https://my-person-api.herokuapp.com/api/v1',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    _repository = PersonRepository(PersonMapper(PhoneMapper()), Dio(options));
    _people = _repository.findAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Peoples")),
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
                itemBuilder: (context, index) {
                  var person = snapshot.data![index];
                  return Dismissible(
                    key: Key("$person.id"),
                    onDismissed: (direction) {
                      setState(() {
                        var removedPerson = snapshot.data!.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(person.firstName + " Deleted sucessful!"),
                            backgroundColor: Colors.green,
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  snapshot.data!.add(removedPerson);
                                });
                              },
                            ),
                          ),
                        );

                        // _repository.deletePersonById(person.id);
                      });
                    },
                    child: ListTile(
                      title: Text(person.firstName + ' ' + person.lastName),
                      subtitle: Text(person.cpf),
                      // trailing: Icon(Icons.plus_one),
                    ),
                    background: Container(
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.person_remove),
                      color: Colors.red,
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
        onPressed: () {
          setState(() {
            _people = _repository.findAll();
          });
        },
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
}
