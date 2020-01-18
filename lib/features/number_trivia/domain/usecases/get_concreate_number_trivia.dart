import 'package:clean_arch/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreateNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreateNumberTrivia(this.repository);

  @override
  Future<Either<Failuer, NumberTrivia>> call(Params params) async {
    return await repository.getConcreateNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
