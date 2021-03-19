abstract class IRepository<T> {
  T fromMap(Map map);
  Map toMap();
  void setId(String id);
}
