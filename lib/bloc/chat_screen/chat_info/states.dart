import 'package:catch_me/models/Person.dart';

class ChatInfoState {}

class ChatInfoIsLoading extends ChatInfoState {}

class ChatInfoLoadedState extends ChatInfoState {
    final Person person;

    ChatInfoLoadedState(this.person);
}
