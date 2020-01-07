import 'package:equatable/equatable.dart';

abstract class Failuer extends Equatable {
  Failuer([List properties = const <dynamic>[]]) : super(properties);
}

// General Failures
class ServerFailure extends Failuer {}
class CacheFailure extends Failuer {}
