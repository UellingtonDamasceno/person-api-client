import 'phone.dart';

class Person {
  int _id;
  String _firstName;
  String _lastName;
  String _cpf;
  String _birthDate;
  List<Phone> _phones;

  Person(this._id, this._firstName, this._lastName, this._cpf, this._birthDate,
      this._phones);

  int get id => this._id;
  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get cpf => this._cpf;
  String get birthDate => this._birthDate;
  List<Phone> get phones => this._phones;

  set id(int id) => this._id = id;
  set firstName(String firstName) => this._firstName = firstName;
  set lastName(String lastName) => this._lastName = lastName;
  set cpf(String cpf) => this._cpf = cpf;
  set birthDate(String birthDate) => this._birthDate = birthDate;
  set phones(List<Phone> phones) => this._phones = phones;

  String toString() {
    return this.firstName + " " + this.lastName;
  }
}
