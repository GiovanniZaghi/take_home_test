import 'package:fpdart/fpdart.dart';
import 'package:take_home_test/domain/entities/entities.dart';
import 'package:take_home_test/domain/failure/failure.dart';

abstract class CreateAliasUseCase {
  Future<Either<GenericFailure, AliasEntity>> call(String url);
}
