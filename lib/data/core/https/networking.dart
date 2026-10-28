import 'package:take_home_test/data/core/https/take_home_response.dart';

abstract class Networking {
  Future<TakeHomeResponse<T>> get<T>(
    String path, {
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<TakeHomeResponse<T>> post<T>(
    String path, {
    String? baseUrl,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  });
}
