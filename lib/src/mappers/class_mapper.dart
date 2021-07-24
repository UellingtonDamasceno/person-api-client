abstract class ClassMapper<T> {
  Map<String, dynamic> toJson(T data);

  T fromJson(Map<String, dynamic> data);
}
