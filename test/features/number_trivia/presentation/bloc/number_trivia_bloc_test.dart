import 'package:clean_arch/core/error/failures.dart';
import 'package:clean_arch/core/usecases/usecase.dart';
import 'package:clean_arch/core/utils/input_converter.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreateNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initial test should be Empty', () async {
    expect(bloc.initialState, equals(Empty()));
  });

  group(
    'GetTriviaForConcreteNumber',
    () {
      final tNumberString = '1';
      final tNumberParsed = 1;
      final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

      void setUpMockInputConverterSuccess() =>
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          //act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          //asert
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );

      test(
        'should emit [Error] when the input is invalid',
        () async {
          //arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
          //asert later
          final expected = [
            Empty(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          //acts
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        'should get data from the concrete use case',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockGetConcreteNumberTrivia(any));
          //asert
          verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfuly',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //asert later
          final expected = [
            Empty(),
            Loading(),
            Loaded(trivia: tNumberTrivia),
          ];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          //act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          //asert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          //act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        'should emit [Loading, Error] with proper message for the error when getting data fails',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          //asert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          //act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );
    },
  );

  group(
    'GetTriviaForRandomNumber',
    () {
      final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
      test(
        'should get data from the random use case',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //act
          bloc.add(GetTriviaForRandomNumber());
          await untilCalled(mockGetRandomNumberTrivia(any));
          //asert
          verify(mockGetRandomNumberTrivia(NoParams()));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfuly',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //asert later
          final expected = [
            Empty(),
            Loading(),
            Loaded(trivia: tNumberTrivia),
          ];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          //act
          bloc.add(GetTriviaForRandomNumber());
        },
      );

      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          //asert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          //act
          bloc.add(GetTriviaForRandomNumber());
        },
      );

      test(
        'should emit [Loading, Error] with proper message for the error when getting data fails',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          //asert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          //act
          bloc.add(GetTriviaForRandomNumber());
        },
      );
    },
  );
}
