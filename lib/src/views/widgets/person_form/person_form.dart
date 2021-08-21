import 'package:flutter/material.dart';
import 'package:person_api_client/src/models/person.dart';
import 'package:person_api_client/src/models/phone.dart';
import 'package:person_api_client/src/views/pages/person_list/person_list_bloc.dart';

class PersonForm extends StatefulWidget {
  final PersonListBloc personListBloc;
  const PersonForm({Key? key, required this.personListBloc}) : super(key: key);

  @override
  _PersonFormState createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  Person _person = Person.empty();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Adicionar pessoa",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(labelText: 'Nome'),
              controller: firstNameController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Sobrenome'),
              controller: lastNameController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'CPF'),
              controller: cpfController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Telefone'),
              controller: phoneController,
            ),
            ElevatedButton(
                onPressed: () {
                  _person.firstName = firstNameController.text;
                  _person.lastName = lastNameController.text;
                  _person.cpf = cpfController.text;
                  _person.phones = [Phone.comercial(phoneController.text)];
                  widget.personListBloc.save(_person);
                },
                child: Text("Salvar"))
          ],
        ),
      ),
    );
  }
}
