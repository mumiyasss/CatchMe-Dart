import 'package:meta/meta.dart';

@immutable
abstract class BlockingEvent {}

class BlockUser extends BlockingEvent {}
class UnblockUser extends BlockingEvent {}
