import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:take_home_test/domain/domain.dart';
import 'package:take_home_test/presentation/cubit/cubit.dart';

class MockCreateAliasUseCase extends Mock implements CreateAliasUseCase {}

void main() {
  late MockCreateAliasUseCase mockUseCase;

  const tUrl = 'https://google.com';
  const tUrl2 = 'https://flutter.dev';

  const tAlias = AliasEntity(
    alias: 'abc',
    originalUrl: tUrl,
    shortUrl: 'https://short.io/abc',
  );

  const tAlias2 = AliasEntity(
    alias: 'xyz',
    originalUrl: tUrl2,
    shortUrl: 'https://short.io/xyz',
  );

  setUp(() {
    mockUseCase = MockCreateAliasUseCase();
  });

  group('TakeHomeCubit', () {
    test('initial state is TakeHomeInitial with empty aliases', () {
      final cubit = TakeHomeCubit(mockUseCase);
      expect(cubit.state, const TakeHomeInitial());
      expect(cubit.state.aliases, isEmpty);
      cubit.close();
    });

    blocTest<TakeHomeCubit, TakeHomeState>(
      'emits [Loading([]), Loaded([alias])] on success',
      build: () {
        when(() => mockUseCase(tUrl))
            .thenAnswer((_) async => const Right(tAlias));
        return TakeHomeCubit(mockUseCase);
      },
      act: (cubit) => cubit.shortenUrl(tUrl),
      expect: () => [
        const TakeHomeLoading([]),
        const TakeHomeLoaded([tAlias]),
      ],
    );

    blocTest<TakeHomeCubit, TakeHomeState>(
      'emits [Loading([]), Error] on use case failure',
      build: () {
        when(() => mockUseCase(tUrl)).thenAnswer(
          (_) async => const Left(GenericFailure('network error')),
        );
        return TakeHomeCubit(mockUseCase);
      },
      act: (cubit) => cubit.shortenUrl(tUrl),
      expect: () => [
        const TakeHomeLoading([]),
        const TakeHomeError(message: 'network error', aliases: []),
      ],
    );

    blocTest<TakeHomeCubit, TakeHomeState>(
      'accumulates history inserting newest alias at index 0',
      build: () {
        when(() => mockUseCase(tUrl))
            .thenAnswer((_) async => const Right(tAlias));
        when(() => mockUseCase(tUrl2))
            .thenAnswer((_) async => const Right(tAlias2));
        return TakeHomeCubit(mockUseCase);
      },
      act: (cubit) async {
        await cubit.shortenUrl(tUrl);
        await cubit.shortenUrl(tUrl2);
      },
      expect: () => [
        const TakeHomeLoading([]),
        const TakeHomeLoaded([tAlias]),
        const TakeHomeLoading([tAlias]),
        const TakeHomeLoaded([tAlias2, tAlias]),
      ],
    );

    blocTest<TakeHomeCubit, TakeHomeState>(
      'history is preserved in Error state — previous aliases remain',
      build: () {
        when(() => mockUseCase(tUrl))
            .thenAnswer((_) async => const Right(tAlias));
        when(() => mockUseCase('bad-url')).thenAnswer(
          (_) async => const Left(GenericFailure('invalid')),
        );
        return TakeHomeCubit(mockUseCase);
      },
      act: (cubit) async {
        await cubit.shortenUrl(tUrl);
        await cubit.shortenUrl('bad-url');
      },
      expect: () => [
        const TakeHomeLoading([]),
        const TakeHomeLoaded([tAlias]),
        const TakeHomeLoading([tAlias]),
        const TakeHomeError(message: 'invalid', aliases: [tAlias]),
      ],
    );

    blocTest<TakeHomeCubit, TakeHomeState>(
      'Loading state carries current history snapshot',
      build: () {
        when(() => mockUseCase(tUrl))
            .thenAnswer((_) async => const Right(tAlias));
        when(() => mockUseCase(tUrl2))
            .thenAnswer((_) async => const Right(tAlias2));
        return TakeHomeCubit(mockUseCase);
      },
      act: (cubit) async {
        await cubit.shortenUrl(tUrl);
        await cubit.shortenUrl(tUrl2);
      },
      expect: () => [
        const TakeHomeLoading([]),
        const TakeHomeLoaded([tAlias]),
        const TakeHomeLoading([tAlias]),
        const TakeHomeLoaded([tAlias2, tAlias]),
      ],
      verify: (cubit) {
        verify(() => mockUseCase(tUrl)).called(1);
        verify(() => mockUseCase(tUrl2)).called(1);
      },
    );
  });
}
