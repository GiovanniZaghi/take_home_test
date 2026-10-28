import 'package:fpdart/fpdart.dart';
import 'package:take_home_test/data/datasource/datasource.dart';
import 'package:take_home_test/domain/entities/entities.dart';
import 'package:take_home_test/domain/failure/failure.dart';
import 'package:take_home_test/domain/repository/repository.dart';

class TakeHomeRepositoryImpl implements TakeHomeRepository {
  TakeHomeRepositoryImpl(this._datasource);

  final TakeHomeDatasource _datasource;

  @override
  Future<Either<GenericFailure, AliasEntity>> createAlias(
    String url,
  ) async {
    final response = await _datasource.createAlias(url);

    return response.fold(Left.new, (response) => Right(response.toEntity()));
  }

  @override
  Future<Either<GenericFailure, String>> getOriginalUrl(
    String alias,
  ) async {
    final response = await _datasource.getOriginalUrl(alias);

    return response.fold(Left.new, Right.new);
  }
}
