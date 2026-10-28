import 'package:fpdart/fpdart.dart';
import 'package:take_home_test/data/model/model.dart';
import 'package:take_home_test/domain/failure/failure.dart';

abstract class TakeHomeDatasource {
  Future<Either<GenericFailure, AliasModel>> createAlias(String url);
  Future<Either<GenericFailure, String>> getOriginalUrl(String alias);
}
