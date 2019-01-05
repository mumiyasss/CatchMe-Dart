import 'package:catch_me/models/Car.dart';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'CarBean.jorm.dart';

@GenBean()
class CarBean extends Bean<Car> with _CarBean {
  CarBean(Adapter adapter) : super(adapter);
  String tableName = 'car';
}
