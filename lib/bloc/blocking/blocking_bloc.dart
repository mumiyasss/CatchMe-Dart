import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:catch_me/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './bloc.dart';

class BlockingBloc extends Bloc<BlockingEvent, BlockingState> {
    static CollectionReference _blockingCollection = _initBlockingRef();

    static _initBlockingRef() {
        assert(App.userUid != null);
        _blockingCollection = Firestore.instance.collection('blocked_users')
            .document(App.userUid).collection('blocked');
        return _blockingCollection;
    }

    Observable<bool> blockState;

    final String companionId;

    BlockingBloc(this.companionId) {
        blockState =
            Observable(_blockingCollection.document(companionId).snapshots())
                .map<bool>((DocumentSnapshot updatedData) {
                print('blocked data is ${updatedData.data['blocked']}');
                if (updatedData.data['blocked'] == true) {
                    return true;
                } else
                    return false;
            });
    }

    @override
    BlockingState get initialState => InitialBlockingState();

    @override
    Stream<BlockingState> mapEventToState(BlockingEvent event,) async* {

        if (event is BlockUser) {
            print("Block gesture registered");
            _blockingCollection.document(companionId).setData(
                {'blocked': true});
        }
        if (event is UnblockUser) {
            print("Unblock gesture registered");
            _blockingCollection.document(companionId).setData(
                {'blocked': false});
        }
    }
}
