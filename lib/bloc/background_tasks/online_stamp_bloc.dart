import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';

class OnlineStampBloc extends Bloc<OnlineStampEvent, OnlineStampState> {

    @override
    OnlineStampState get initialState {
        return OnlineStampState();
    }

    static var isSending = false;

    @override
    Stream<OnlineStampState> mapEventToState(OnlineStampEvent event) async* {
        if (event is SendStamp) {
            isSending = true;
            _sendStamp();
        }
        if (event is StopSendingStamp) {
            isSending = false;
        }
        yield OnlineStampState();
    }

    _sendStamp() async {
        await Future.delayed(Duration(seconds: 15)).then((_) {
            if (isSending) {
                CloudFunctions.instance
                    .getHttpsCallable(
                    functionName: 'iAmOnline',
                ).call();
                _sendStamp();
            }
        });
    }

}




class OnlineStampEvent {}
class OnlineStampState {}

class SendStamp extends OnlineStampEvent {}
class StopSendingStamp extends OnlineStampEvent {}