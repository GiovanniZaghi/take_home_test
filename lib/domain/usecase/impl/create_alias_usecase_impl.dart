import 'package:fpdart/fpdart.dart';
import 'package:take_home_test/domain/domain.dart';

class CreateAliasUseCaseImpl implements CreateAliasUseCase {
  const CreateAliasUseCaseImpl(this.repository);

  final TakeHomeRepository repository;

  @override
  Future<Either<GenericFailure, AliasEntity>> call(String url) =>
      repository.createAlias(url);
}
