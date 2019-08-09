import 'package:catch_me/dao/cached_db/store.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class PersonDao {
    static PersonDao _instance;
    static PersonStore _personStore;

    static Future<PersonDao> get instance async {
        if (_instance == null) {
            _personStore = await PersonStore.instance;
            _instance = PersonDao._();
        }
        return _instance;
    }

    PersonDao._();

    // Необходимо сделать мерж с данными из Store.
    Observable<Person> fromUserId(String userId) {
        assert(userId != null);
        var observable = Observable(Firestore
            .instance
            .collection('users')
            .document(userId)
            .snapshots());

        return Observable.just(_personStore.get(userId));


        return observable.map((DocumentSnapshot personSnapshot) {
            var person = Person.fromSnapshot(personSnapshot);
            _personStore.insert(person);
            assert(person != null);
            return person;
        });
    }

    // сделать в стрим?
    Observable<Person> fromPrivateChatMembers(List members) {
        for (var memberId in members) {
            if (memberId != CatchMeApp.userUid) {
                print(memberId);
                return fromUserId(memberId);
            }
        }
        return fromUserId(CatchMeApp.userUid);
    }

}