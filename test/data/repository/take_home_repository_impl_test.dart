import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:take_home_test/data/datasource/datasource.dart';
import 'package:take_home_test/data/model/model.dart';
import 'package:take_home_test/data/repository/impl/take_home_repository_impl.dart';
import 'package:take_home_test/domain/entities/entities.dart';
import 'package:take_home_test/domain/failure/failure.dart';

class MockTakeHomeDatasource extends Mock implements TakeHomeDatasource {}

void main() {
  late MockTakeHomeDatasource mockDatasource;
  late TakeHomeRepositoryImpl repository;

  const tAlias = 'abc123';
  const tUrl = 'https://google.com';
  const tShortUrl = 'https://short.io/abc123';

  const tModel = AliasModel(
    alias: tAlias,
    originalUrl: tUrl,
    shortUrl: tShortUrl,
  );

  const tEntity = AliasEntity(
    alias: tAlias,
    originalUrl: tUrl,
    shortUrl: tShortUrl,
  );

  setUp(() {
    mockDatasource = MockTakeHomeDatasource();
    repository = TakeHomeRepositoryImpl(mockDatasource);
  });

  group('TakeHomeRepositoryImpl', () {
    group('createAlias', () {
      test('returns Right(AliasEntity) mapping model via toEntity on success',
          () async {
        when(() => mockDatasource.createAlias(tUrl))
            .thenAnswer((_) async => const Right(tModel));

        final result = await repository.createAlias(tUrl);

        expect(result, const Right(tEntity));
      });

      test('returns Left propagating datasource failure', () async {
        const failure = GenericFailure('error');
        when(() => mockDatasource.createAlias(tUrl))
            .thenAnswer((_) async => const Left(failure));

        final result = await repository.createAlias(tUrl);

        expect(result, const Left(failure));
      });

      test('delegates to datasource with correct url', () async {
        when(() => mockDatasource.createAlias(tUrl))
            .thenAnswer((_) async => const Right(tModel));

        await repository.createAlias(tUrl);

        verify(() => mockDatasource.createAlias(tUrl)).called(1);
      });
    });

    group('getOriginalUrl', () {
      test('returns Right(url) on datasource success', () async {
        when(() => mockDatasource.getOriginalUrl(tAlias))
            .thenAnswer((_) async => const Right(tUrl));

        final result = await repository.getOriginalUrl(tAlias);

        expect(result, const Right(tUrl));
      });

      test('returns Left propagating datasource failure', () async {
        const failure = GenericFailure('not found');
        when(() => mockDatasource.getOriginalUrl(tAlias))
            .thenAnswer((_) async => const Left(failure));

        final result = await repository.getOriginalUrl(tAlias);

        expect(result, const Left(failure));
      });
    });
  });
}
