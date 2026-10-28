import 'package:dio/dio.dart';
import 'package:take_home_test/data/core/https/networking.dart';
import 'package:take_home_test/data/core/https/take_home_response.dart';

class NetworkingImpl implements Networking {
  const NetworkingImpl(this._dio);

  final Dio _dio;

  String _buildUrl(String path, String? baseUrl) =>
      baseUrl != null ? '$baseUrl$path' : path;

  @override
  Future<TakeHomeResponse<T>> get<T>(
    String path, {
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.get<T>(
      _buildUrl(path, baseUrl),
      queryParameters: queryParameters,
      options: headers != null ? Options(headers: headers) : null,
    );
    return TakeHomeResponse(
      data: response.data as T,
      statusCode: response.statusCode!,
    );
  }

  @override
  Future<TakeHomeResponse<T>> post<T>(
    String path, {
    String? baseUrl,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.post<T>(
      _buildUrl(path, baseUrl),
      data: data,
      options: headers != null ? Options(headers: headers) : null,
    );
    return TakeHomeResponse(
      data: response.data as T,
      statusCode: response.statusCode!,
    );
  }
}
