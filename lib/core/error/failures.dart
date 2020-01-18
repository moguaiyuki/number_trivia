import 'package:equatable/equatable.dart';

abstract class Failuer extends Equatable {
  Failuer();

  @override
  List<Object> get props => null;
}

// General Failures`
class ServerFailure extends Failuer {}
class CacheFailure extends Failuer {}
