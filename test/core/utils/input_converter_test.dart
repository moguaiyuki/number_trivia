import 'package:clean_arch/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test(
      'should return a integer when the string represents an unsigned integer',
      () async {
        //arrange
        final str = '123';
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //asert
        expect(result, Right(123));
      },
    );

    test(
      'should return a Failure when the string is not an integer',
      () async {
        //arrange
        final str = 'abc';
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //asert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a Failure when the string is a negative integer',
      () async {
        //arrange
        final str = '-123';
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //asert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
