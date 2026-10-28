import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:take_home_test/data/core/https/https.dart';
import 'package:take_home_test/data/datasource/datasource.dart';
import 'package:take_home_test/data/datasource/impl/take_home_endpoint_api.dart';
import 'package:take_home_test/data/model/model.dart';
import 'package:take_home_test/domain/failure/failure.dart';

class TakeHomeDatasourceImpl implements TakeHomeDatasource {
  TakeHomeDatasourceImpl(this._networking);

  final Networking _networking;

  String get _baseUrl => dotenv.env['BASE_URL']!.trim();

  @override
  Future<Either<GenericFailure, AliasModel>> createAlias(String url) async {
    try {
      final response = await _networking.post<Map<String, dynamic>>(
        TakeHomeEndpointApi.shortener,
        baseUrl: _baseUrl,
        data: {'url': url},
      );
      return Right(AliasModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(GenericFailure(e.message ?? 'Unexpected error'));
    }
  }

  @override
  Future<Either<GenericFailure, String>> getOriginalUrl(String alias) async {
    try {
      final response = await _networking.get<Map<String, dynamic>>(
        '${TakeHomeEndpointApi.shortener}$alias',
        baseUrl: _baseUrl,
      );
      return Right(response.data['url'] as String);
    } on DioException catch (e) {
      return Left(GenericFailure(e.message ?? 'Unexpected error'));
    }
  }
}
