import 'package:bloc/bloc.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/utils.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

    @override
    SettingsState get initialState {
        return SettingsState();
    }

    /// Преобразует поток событий, данные на сервер отправляются
    /// каждые полсекунды для оптимизации.
    @override
    Stream<SettingsState> transform(
        Stream<SettingsEvent> events,
        Stream<SettingsState> Function(SettingsEvent event) next,
        ) {
        return super.transform(
            (events as Observable<SettingsEvent>).debounceTime(
                Duration(milliseconds: 500),
            ),
            next,
        );
    }

    @override
    Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
        print("in bloc");

        if (event is EmailChangedEvents) {
            // нужно педелать в корне чтобы сохранялся объект person,
            // а потом от сюда послать его измененным в dao!
            CatchMeApp.personDao.updatePersonInfo(event.user..email = event.email);
        }
        if (event is NameChangedEvents) {
            CatchMeApp.personDao.updatePersonInfo(event.user..name = event.name);
        }
        if (event is UploadNewAvatarEvent) {
            var newAvatarUrl = await takePhotoAndUploadToStorage();
            CatchMeApp.personDao.updatePersonInfo(event.user..photoUrl = newAvatarUrl);
        }

        yield SettingsState();
    }
}

abstract class SettingsEvent {
    final Person user;

    SettingsEvent(this.user);

}

class UploadNewAvatarEvent extends SettingsEvent {

    UploadNewAvatarEvent(Person user) : super(user);
}


class EmailChangedEvents extends SettingsEvent {
    final String email;

    EmailChangedEvents(this.email, Person user) : super(user);

}

class NameChangedEvents extends SettingsEvent {
    final String name;

    NameChangedEvents(this.name, Person user) : super(user);


}

class SettingsState {
}