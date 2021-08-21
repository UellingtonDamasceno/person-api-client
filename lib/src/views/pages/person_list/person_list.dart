import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:person_api_client/src/mappers/person_mapper.dart';
import 'package:person_api_client/src/models/person.dart';
import 'package:person_api_client/src/repositories/person_repository.dart';
import 'package:person_api_client/src/views/pages/person_list/person_list_bloc.dart';
import 'package:person_api_client/src/views/widgets/person_form/person_form.dart';

import '../../../mappers/person_mapper.dart';
import '../../../mappers/phone_mapper.dart';
import '../../../repositories/person_repository.dart';

class PersonList extends StatefulWidget {
  const PersonList({Key? key}) : super(key: key);

  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  var _personListBloc;

  @override
  void initState() {
    Dio client = Dio();
    client.options.baseUrl = 'https://my-person-api.herokuapp.com/api/v1';

    PersonMapper personMapper = PersonMapper(PhoneMapper());
    PersonRepository repository = PersonRepository(personMapper, client);

    this._personListBloc = new PersonListBloc(repository);
    this._personListBloc.initialize();
    super.initState();
  }

  @override
  void dispose() {
    this._personListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("People"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<List<Person>>(
          stream: this._personListBloc.streamOut,
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
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        //TODO: Editar
                      } else {
                        _personListBloc.lastRemovedPerson = person;
                        _showDeleteDialogConfirmation(person.id);
                      }
                    },
                    child: ListTile(
                      title: Text(
                        person.firstName + ' ' + person.lastName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${person.cpf}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(Icons.person),
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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return PersonForm(personListBloc: this._personListBloc);
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialogConfirmation(int index) async {
    Person person = this._personListBloc.getById(index);
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
                this._personListBloc.resetLastRemovedPerson();
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
                this._personListBloc.deleteById(index);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$person Deleted sucessful!'),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () {
                        this._personListBloc.resetLastRemovedPerson();
                      },
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
