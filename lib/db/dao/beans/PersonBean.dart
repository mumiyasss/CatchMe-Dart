import 'package:catch_me/db/Db.dart';
import 'package:catch_me/models/Person.dart';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'PersonBean.jorm.dart';

@GenBean()
class PersonBean extends Bean<Person> with _PersonBean {
  PersonBean(Adapter adapter) : super(adapter);
  String tableName = 'person';

  static PersonBean instance;
  static Future<PersonBean> get() async {
    if (instance == null) {
      instance = PersonBean(await Db.getAdapter());
      await instance.createTable(ifNotExists: true);
    }
    return instance;
  }
}
