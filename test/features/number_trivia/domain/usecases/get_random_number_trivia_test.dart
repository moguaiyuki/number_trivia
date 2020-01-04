import 'package:clean_arch/core/usecases/usecase.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRipository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRipository mockNumberTriviaRipository;

  setUp(() {
    mockNumberTriviaRipository = MockNumberTriviaRipository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRipository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRipository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));

      //act
      final result = await usecase(NoParams());

      //asert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRipository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRipository);
    },
  );
}
