import 'package:dio/dio.dart';

import '../models/person.dart';
import '../mappers/class_mapper.dart';

class PersonRepository {
  final ClassMapper<Person> _personMapper;
  final Dio _client;

  PersonRepository(this._personMapper, this._client);

  Future<List<Person>> findAll() async {
    var response = await _client.get<List>('/people');

    return response.data!
        .map<Person>((person) => _personMapper.fromJson(person))
        .toList();
  }

  Future<Person> getPersonById(String id) async {
    var response = await _client.get('/people/$id');
    print(response);
    return _personMapper.fromJson(response.data);
  }

  deletePersonById(int id) async {
    await _client.delete('/people/$id');
  }
}
