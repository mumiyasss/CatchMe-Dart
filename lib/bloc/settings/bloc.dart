import 'package:bloc/bloc.dart';
import 'package:catch_me/main.dart';
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
        if (event is EmailChangedEvents) {
            // нужно педелать в корне чтобы сохранялся объект person,
            // а потом от сюда послать его измененным в dao!
            CatchMeApp.personDao.updatePersonInfo(CatchMeApp.currentUser..email = event.email);
        }
        if (event is NameChangedEvents) {
            CatchMeApp.personDao.updatePersonInfo(CatchMeApp.currentUser..name = event.name);
        }
        yield SettingsState();
    }
}

abstract class SettingsEvent {}

class EmailChangedEvents extends SettingsEvent {
    final String email;

    EmailChangedEvents(this.email);

}

class NameChangedEvents extends SettingsEvent {
    final String name;

    NameChangedEvents(this.name);

}

class SettingsState {
}