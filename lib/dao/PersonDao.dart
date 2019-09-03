import 'package:catch_me/dao/cached_db/store.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'cached_db/db/exceptions.dart';

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

    final usersCollection = Firestore
        .instance
        .collection('users');

    // Необходимо сделать мерж с данными из Store.
    Observable<Person> fromUserId(String userId) {
        assert(userId != null);

        var netObservable = Observable(
            usersCollection.document(userId).snapshots()
        );

        Observable<Person> dbObservable = Observable.empty();
        try {
            var person = _personStore.get(userId);
            dbObservable = Observable.just(person);
        } on NotFound {
            print("Person with $userId ID not found in Database");
        }

        return netObservable.map((DocumentSnapshot personSnapshot) {
            var person = Person.fromSnapshot(personSnapshot);
            _personStore.insert(person);
            assert(person != null);
            return person;
        }).mergeWith([dbObservable]);
    }

    // сделать в стрим?
    Observable<Person> fromPrivateChatMembers(List members) {
        for (var memberId in members) {
            if (memberId != CatchMeApp.userUid) {
                return fromUserId(memberId);
            }
        }
        return fromUserId(CatchMeApp.userUid);
    }

    updatePersonInfo(Person newPersonInfo) {
        // photoUrl - photo, userId - id
        usersCollection
            .document(newPersonInfo.userId)
            .updateData(newPersonInfo.toMap()).then((_) {
                // currentUser не сохраняется в базу данных
                // _personStore.update(newPersonInfo);
        });
    }
}