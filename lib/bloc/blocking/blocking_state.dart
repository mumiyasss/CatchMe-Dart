import 'package:meta/meta.dart';

@immutable
abstract class BlockingState {}

class InitialBlockingState extends BlockingState {}
