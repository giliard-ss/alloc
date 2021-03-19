import 'package:alloc/app/shared/repositories/irepository.dart';

abstract class AbstractEvent extends IRepository {
  String getId();
  DateTime getData();
  String getTipoEvento();
}
