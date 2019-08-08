import 'package:catch_me/models/Person.dart';
import 'package:rxdart/rxdart.dart';

class ChatInfoState {}

class ChatInfoIsLoading extends ChatInfoState {}

class ChatInfoLoadedState extends ChatInfoState {
    final Observable<Person> person;

    ChatInfoLoadedState(this.person);
}
