import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:take_home_test/data/core/https/networking.dart';
import 'package:take_home_test/data/core/https/take_home_response.dart';
import 'package:take_home_test/data/datasource/impl/take_home_datasource_impl.dart';
import 'package:take_home_test/data/datasource/impl/take_home_endpoint_api.dart';
import 'package:take_home_test/data/model/model.dart';

class MockNetworking extends Mock implements Networking {}

void main() {
  late MockNetworking mockNetworking;
  late TakeHomeDatasourceImpl datasource;

  const tBaseUrl = 'https://url-shortener-server.onrender.com';
  const tAlias = 'abc123';
  const tOriginalUrl = 'https://google.com';
  const tShortUrl = '$tBaseUrl${TakeHomeEndpointApi.shortener}$tAlias';

  final tSuccessJson = {
    'alias': tAlias,
    '_links': {
      'self': tOriginalUrl,
      'short': tShortUrl,
    },
  };

  const tExpectedModel = AliasModel(
    alias: tAlias,
    originalUrl: tOriginalUrl,
    shortUrl: tShortUrl,
  );

  setUpAll(() {
    dotenv.testLoad(fileInput: 'BASE_URL=$tBaseUrl');
  });

  setUp(() {
    mockNetworking = MockNetworking();
    datasource = TakeHomeDatasourceImpl(mockNetworking);
  });

  group('TakeHomeDatasourceImpl', () {
    group('createAlias', () {
      test('calls networking.post with shortener endpoint and body', () async {
        when(() => mockNetworking.post<Map<String, dynamic>>(
              TakeHomeEndpointApi.shortener,
              baseUrl: tBaseUrl,
              data: {'url': tOriginalUrl},
            )).thenAnswer(
          (_) async => TakeHomeResponse(data: tSuccessJson, statusCode: 201),
        );

        await datasource.createAlias(tOriginalUrl);

        verify(() => mockNetworking.post<Map<String, dynamic>>(
              TakeHomeEndpointApi.shortener,
              baseUrl: tBaseUrl,
              data: {'url': tOriginalUrl},
            )).called(1);
      });

      test('returns Right(AliasModel) on success', () async {
        when(() => mockNetworking.post<Map<String, dynamic>>(
              TakeHomeEndpointApi.shortener,
              baseUrl: tBaseUrl,
              data: {'url': tOriginalUrl},
            )).thenAnswer(
          (_) async => TakeHomeResponse(data: tSuccessJson, statusCode: 201),
        );

        final result = await datasource.createAlias(tOriginalUrl);

        expect(result, const Right(tExpectedModel));
      });

      test('returns Left(GenericFailure) on DioException', () async {
        when(() => mockNetworking.post<Map<String, dynamic>>(
              any(),
              baseUrl: any(named: 'baseUrl'),
              data: any(named: 'data'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'network error',
        ));

        final result = await datasource.createAlias(tOriginalUrl);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, 'network error'),
          (_) => fail('expected Left'),
        );
      });
    });

    group('getOriginalUrl', () {
      test('calls networking.get with shortener+alias path', () async {
        when(() => mockNetworking.get<Map<String, dynamic>>(
              '${TakeHomeEndpointApi.shortener}$tAlias',
              baseUrl: tBaseUrl,
            )).thenAnswer(
          (_) async => TakeHomeResponse(
            data: {'url': tOriginalUrl},
            statusCode: 200,
          ),
        );

        await datasource.getOriginalUrl(tAlias);

        verify(() => mockNetworking.get<Map<String, dynamic>>(
              '${TakeHomeEndpointApi.shortener}$tAlias',
              baseUrl: tBaseUrl,
            )).called(1);
      });

      test('returns Right(url) on success', () async {
        when(() => mockNetworking.get<Map<String, dynamic>>(
              '${TakeHomeEndpointApi.shortener}$tAlias',
              baseUrl: tBaseUrl,
            )).thenAnswer(
          (_) async => TakeHomeResponse(
            data: {'url': tOriginalUrl},
            statusCode: 200,
          ),
        );

        final result = await datasource.getOriginalUrl(tAlias);

        expect(result, const Right(tOriginalUrl));
      });

      test('returns Left(GenericFailure) on DioException', () async {
        when(() => mockNetworking.get<Map<String, dynamic>>(
              any(),
              baseUrl: any(named: 'baseUrl'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'not found',
        ));

        final result = await datasource.getOriginalUrl(tAlias);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, 'not found'),
          (_) => fail('expected Left'),
        );
      });
    });
  });
}
