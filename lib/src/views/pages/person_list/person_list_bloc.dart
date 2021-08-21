import 'dart:async';

import 'package:person_api_client/src/models/person.dart';
import 'package:person_api_client/src/repositories/person_repository.dart';

class PersonListBloc {
  final PersonRepository _repository;
  final StreamController _streamController =
      StreamController<List<Person>>.broadcast();
  Stream get streamOut => _streamController.stream;
  Sink get streamIn => _streamController.sink;

  List<Person> _people = [];

  var lastRemovedPerson;

  PersonListBloc(this._repository);

  void initialize() {
    _repository
        .findAll()
        .then(_updatePeopleList)
        .onError((error, stackTrace) => Stream.error("Error ao buscar dados."));
    this.streamIn.add(_people);
  }

  void findAll() {
    _repository
        .findAll()
        .then(streamIn.add)
        .onError((error, stackTrace) => Stream.error("Error ao buscar dados."));
  }

  void deleteById(int id) {
    lastRemovedPerson = _people.firstWhere((element) => element.id == id);
    _people.removeWhere((element) => element.id == id);
    streamIn.add(_people);
  }

  void save(Person person) {
    this._repository.save(person);
    _people.add(person);
    streamIn.add(_people);
  }

  Person getById(int id) {
    print(id);
    return _people.firstWhere((element) => element.id == id);
  }

  void resetLastRemovedPerson() {
    if (lastRemovedPerson == null) {
      return;
    }
    streamIn.add(_people);
  }

  _updatePeopleList(List<Person> people) {
    this._people.addAll(people);
    this.streamIn.add(_people);
  }

  void dispose() {
    _streamController.close();
  }
}
