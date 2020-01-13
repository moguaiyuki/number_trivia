import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:clean_arch/core/error/exceptions.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttoClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Some thins is wrong', 404));
  }

  group('getConcreateNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number 
      being the endpoint and with application/json header''',
      () async {
        //arrange
        setUpMockHttoClientSuccess200();
        //act
        dataSource.getConcreateNumberTrivia(tNumber);
        //asert
        verify(
          mockHttpClient.get(
            'http://numbersapi.com/$tNumber',
            headers: {
              'content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return NumberTriviaModel when the satus code is 200 (success)',
      () async {
        //arrange
        setUpMockHttoClientSuccess200();
        //act
        final result = await dataSource.getConcreateNumberTrivia(tNumber);
        //asert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        //arrange
        setUpMockHttpClientFailure404();
        //act
        final call = dataSource.getConcreateNumberTrivia;
        //asert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number 
      being the endpoint and with application/json header''',
      () async {
        //arrange
        setUpMockHttoClientSuccess200();
        //act
        dataSource.getRandomNumberTrivia();
        //asert
        verify(
          mockHttpClient.get(
            'http://numbersapi.com/random',
            headers: {
              'content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return NumberTriviaModel when the satus code is 200 (success)',
      () async {
        //arrange
        setUpMockHttoClientSuccess200();
        //act
        final result = await dataSource.getRandomNumberTrivia();
        //asert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        //arrange
        setUpMockHttpClientFailure404();
        //act
        final call = dataSource.getRandomNumberTrivia;
        //asert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
