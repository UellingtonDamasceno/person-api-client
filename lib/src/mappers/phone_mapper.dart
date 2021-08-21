import '../models/phone.dart';
import './class_mapper.dart';

class PhoneMapper extends ClassMapper<Phone> {
  @override
  Phone fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    String type = json['type'];
    String number = json['number'];
    return new Phone(id, type, number);
  }

  @override
  Map<String, dynamic> toJson(Phone phone) {
    final Map<String, dynamic> data = new Map();
    data['type'] = phone.type;
    data['number'] = phone.number;
    return data;
  }
}
