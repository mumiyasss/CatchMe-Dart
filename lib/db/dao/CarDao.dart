import 'package:catch_me/db/Db.dart';
import 'package:catch_me/db/dao/beans/CarBean.dart';
import 'package:catch_me/models/Car.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class CarDao {
  void fun() async {
    
    final carBean = CarBean(await Db.getAdapter());
    await carBean.createTable();

    {
      final car = Car()
        ..name = 'Volvo'
        ..carModel = 'v50'
        ..brand = 'Volvo';

      int id = await carBean.insert(car);

      print("New model = " + id.toString());
      final nc = await carBean.find(id, preload: true);
      print("New model: " + nc.toString());
    }
  }
}
