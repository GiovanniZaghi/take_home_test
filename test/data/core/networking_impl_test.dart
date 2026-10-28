import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:take_home_test/data/core/https/networking_impl.dart';
import 'package:take_home_test/data/core/https/take_home_response.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late NetworkingImpl networking;

  const tBaseUrl = 'https://api.example.com';
  const tPath = '/resource';
  const tAlias = 'abc123';

  setUp(() {
    mockDio = MockDio();
    networking = NetworkingImpl(mockDio);
  });

  group('NetworkingImpl', () {
    group('get', () {
      test('calls dio.get with path only when baseUrl is null', () async {
        when(() => mockDio.get<Map<String, dynamic>>(tPath))
            .thenAnswer((_) async => Response(
                  data: {'key': 'value'},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: tPath),
                ));

        await networking.get<Map<String, dynamic>>(tPath);

        verify(() => mockDio.get<Map<String, dynamic>>(tPath)).called(1);
      });

      test('calls dio.get with baseUrl+path when baseUrl is provided', () async {
        final fullUrl = '$tBaseUrl$tPath';
        when(() => mockDio.get<Map<String, dynamic>>(fullUrl))
            .thenAnswer((_) async => Response(
                  data: {'key': 'value'},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: fullUrl),
                ));

        await networking.get<Map<String, dynamic>>(tPath, baseUrl: tBaseUrl);

        verify(() => mockDio.get<Map<String, dynamic>>(fullUrl)).called(1);
      });

      test('passes queryParameters to dio.get', () async {
        const params = {'page': '1'};
        when(() => mockDio.get<Map<String, dynamic>>(
              tPath,
              queryParameters: params,
            )).thenAnswer((_) async => Response(
              data: {},
              statusCode: 200,
              requestOptions: RequestOptions(path: tPath),
            ));

        await networking.get<Map<String, dynamic>>(
          tPath,
          queryParameters: params,
        );

        verify(() => mockDio.get<Map<String, dynamic>>(
              tPath,
              queryParameters: params,
            )).called(1);
      });

      test('returns TakeHomeResponse with data and statusCode', () async {
        final tData = {'url': 'https://original.com'};
        when(() => mockDio.get<Map<String, dynamic>>(
              '$tBaseUrl/$tAlias',
            )).thenAnswer((_) async => Response(
              data: tData,
              statusCode: 200,
              requestOptions: RequestOptions(path: '$tBaseUrl/$tAlias'),
            ));

        final result = await networking.get<Map<String, dynamic>>(
          '/$tAlias',
          baseUrl: tBaseUrl,
        );

        expect(result, isA<TakeHomeResponse<Map<String, dynamic>>>());
        expect(result.data, tData);
        expect(result.statusCode, 200);
      });

      test('propagates DioException without catching', () async {
        when(() => mockDio.get<Map<String, dynamic>>(any())).thenThrow(
          DioException(requestOptions: RequestOptions(path: tPath)),
        );

        expect(
          () => networking.get<Map<String, dynamic>>(tPath),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('post', () {
      test('calls dio.post with path only when baseUrl is null', () async {
        when(() => mockDio.post<Map<String, dynamic>>(tPath))
            .thenAnswer((_) async => Response(
                  data: {'alias': 'abc'},
                  statusCode: 201,
                  requestOptions: RequestOptions(path: tPath),
                ));

        await networking.post<Map<String, dynamic>>(tPath);

        verify(() => mockDio.post<Map<String, dynamic>>(tPath)).called(1);
      });

      test('calls dio.post with baseUrl+path when baseUrl is provided', () async {
        final fullUrl = '$tBaseUrl$tPath';
        when(() => mockDio.post<Map<String, dynamic>>(fullUrl))
            .thenAnswer((_) async => Response(
                  data: {},
                  statusCode: 201,
                  requestOptions: RequestOptions(path: fullUrl),
                ));

        await networking.post<Map<String, dynamic>>(tPath, baseUrl: tBaseUrl);

        verify(() => mockDio.post<Map<String, dynamic>>(fullUrl)).called(1);
      });

      test('passes data body to dio.post', () async {
        const tBody = {'url': 'https://google.com'};
        when(() => mockDio.post<Map<String, dynamic>>(
              tBaseUrl,
              data: tBody,
            )).thenAnswer((_) async => Response(
              data: {},
              statusCode: 201,
              requestOptions: RequestOptions(path: tBaseUrl),
            ));

        await networking.post<Map<String, dynamic>>(
          '',
          baseUrl: tBaseUrl,
          data: tBody,
        );

        verify(() => mockDio.post<Map<String, dynamic>>(
              tBaseUrl,
              data: tBody,
            )).called(1);
      });

      test('returns TakeHomeResponse with data and statusCode', () async {
        final tData = {
          'alias': tAlias,
          '_links': {'self': 'https://google.com', 'short': '$tBaseUrl/$tAlias'},
        };
        when(() => mockDio.post<Map<String, dynamic>>(
              tBaseUrl,
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
              data: tData,
              statusCode: 201,
              requestOptions: RequestOptions(path: tBaseUrl),
            ));

        final result = await networking.post<Map<String, dynamic>>(
          '',
          baseUrl: tBaseUrl,
          data: {'url': 'https://google.com'},
        );

        expect(result, isA<TakeHomeResponse<Map<String, dynamic>>>());
        expect(result.data, tData);
        expect(result.statusCode, 201);
      });

      test('propagates DioException without catching', () async {
        when(() => mockDio.post<Map<String, dynamic>>(any())).thenThrow(
          DioException(requestOptions: RequestOptions(path: tPath)),
        );

        expect(
          () => networking.post<Map<String, dynamic>>(tPath),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
}
