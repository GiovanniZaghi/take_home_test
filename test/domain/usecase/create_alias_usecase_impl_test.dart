import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:take_home_test/domain/domain.dart';

class MockTakeHomeRepository extends Mock implements TakeHomeRepository {}

void main() {
  late MockTakeHomeRepository mockRepository;
  late CreateAliasUseCaseImpl useCase;

  const tUrl = 'https://google.com';
  const tEntity = AliasEntity(
    alias: 'abc',
    originalUrl: tUrl,
    shortUrl: 'https://short.io/abc',
  );

  setUp(() {
    mockRepository = MockTakeHomeRepository();
    useCase = CreateAliasUseCaseImpl(mockRepository);
  });

  group('CreateAliasUseCaseImpl', () {
    test('delegates call to repository.createAlias', () async {
      when(() => mockRepository.createAlias(tUrl))
          .thenAnswer((_) async => const Right(tEntity));

      await useCase(tUrl);

      verify(() => mockRepository.createAlias(tUrl)).called(1);
    });

    test('returns Right(AliasEntity) on repository success', () async {
      when(() => mockRepository.createAlias(tUrl))
          .thenAnswer((_) async => const Right(tEntity));

      final result = await useCase(tUrl);

      expect(result, const Right(tEntity));
    });

    test('returns Left(GenericFailure) on repository failure', () async {
      const failure = GenericFailure('network error');
      when(() => mockRepository.createAlias(tUrl))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(tUrl);

      expect(result, const Left(failure));
    });
  });
}
