import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failuer, NumberTrivia>> getConcreateNumberTrivia(int number);
  Future<Either<Failuer, NumberTrivia>> getRandomNumberTrivia();
}
