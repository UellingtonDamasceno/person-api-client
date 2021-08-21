import '../models/person.dart';
import '../models/phone.dart';

import './class_mapper.dart';

class PersonMapper extends ClassMapper<Person> {
  final ClassMapper<Phone> _phoneMapper;

  PersonMapper(this._phoneMapper);

  @override
  Person fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    String cpf = json['cpf'];
    String firstName = json['firstName'];
    String lastName = json['lastName'];
    String birthDate = json['birthDate'];

    List<Phone> phones = [];
    if (json['phones'] != null) {
      phones = json['phones']
          .map<Phone>((phone) => _phoneMapper.fromJson(phone))
          .toList();
    }

    return new Person(id, firstName, lastName, cpf, birthDate, phones);
  }

  @override
  Map<String, dynamic> toJson(Person person) {
    final Map<String, dynamic> data = new Map();
    data['firstName'] = person.firstName;
    data['lastName'] = person.lastName;
    data['cpf'] = person.cpf;
    data['birthDate'] = person.birthDate;

    data['phones'] =
        person.phones.map((phone) => _phoneMapper.toJson(phone)).toList();
    return data;
  }
}
