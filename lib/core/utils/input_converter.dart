import 'package:clean_arch/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failuer, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failuer {}
