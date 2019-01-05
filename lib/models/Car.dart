import 'package:jaguar_orm/jaguar_orm.dart';

class Car {
  @PrimaryKey(auto: true)
  int id;
  String name = '';
  String brand = '';
  String carModel = '';
}
