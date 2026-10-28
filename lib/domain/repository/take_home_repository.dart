import 'package:fpdart/fpdart.dart';
import 'package:take_home_test/domain/entities/entities.dart';

import '../failure/failure.dart';

abstract interface class TakeHomeRepository {
  Future<Either<GenericFailure, AliasEntity>> createAlias(String url);
  Future<Either<GenericFailure, String>> getOriginalUrl(String alias);
}
