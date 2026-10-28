import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:take_home_test/domain/domain.dart';
import 'package:take_home_test/presentation/cubit/cubit.dart';
import 'package:take_home_test/presentation/view/take_home_view.dart';

class _MockCreateAliasUseCase extends Mock implements CreateAliasUseCase {}

class _TestModule extends Module {
  _TestModule(this._useCase);
  final CreateAliasUseCase _useCase;

  @override
  void binds(Injector i) {
    i.addSingleton<TakeHomeCubit>(() => TakeHomeCubit(_useCase));
  }

  @override
  void routes(RouteManager r) {}
}

void main() {
  late _MockCreateAliasUseCase mockUseCase;

  const tUrl = 'https://google.com';
  const tUrl2 = 'https://flutter.dev';

  const tAlias = AliasEntity(
    alias: 'abc123',
    originalUrl: tUrl,
    shortUrl: 'https://short.ly/abc123',
  );

  const tAlias2 = AliasEntity(
    alias: 'xyz789',
    originalUrl: tUrl2,
    shortUrl: 'https://short.ly/xyz789',
  );

  setUp(() {
    mockUseCase = _MockCreateAliasUseCase();
    Modular.init(_TestModule(mockUseCase));
  });

  tearDown(Modular.destroy);

  Widget buildSubject() => const MaterialApp(home: TakeHomeView());

  group('TakeHomeView — URL shortening flow', () {
    testWidgets('submitting a valid URL renders the alias in the list',
        (tester) async {
      when(() => mockUseCase(tUrl))
          .thenAnswer((_) async => const Right(tAlias));

      await tester.pumpWidget(buildSubject());
      await tester.enterText(find.byType(TextField), tUrl);
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.text(tAlias.shortUrl), findsOneWidget);
      expect(find.text(tAlias.originalUrl), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator while use case is pending',
        (tester) async {
      final completer = Completer<Either<GenericFailure, AliasEntity>>();
      when(() => mockUseCase(tUrl)).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildSubject());
      await tester.enterText(find.byType(TextField), tUrl);
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsNothing);

      completer.complete(const Right(tAlias));
      await tester.pumpAndSettle();
    });

    testWidgets('shows SnackBar with error message when use case fails',
        (tester) async {
      when(() => mockUseCase(tUrl)).thenAnswer(
        (_) async => const Left(GenericFailure('network error')),
      );

      await tester.pumpWidget(buildSubject());
      await tester.enterText(find.byType(TextField), tUrl);
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('network error'), findsOneWidget);
    });

    testWidgets('error does not clear previous aliases from the list',
        (tester) async {
      when(() => mockUseCase(tUrl))
          .thenAnswer((_) async => const Right(tAlias));
      when(() => mockUseCase('bad-url')).thenAnswer(
        (_) async => const Left(GenericFailure('invalid url')),
      );

      await tester.pumpWidget(buildSubject());

      await tester.enterText(find.byType(TextField), tUrl);
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'bad-url');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.text(tAlias.shortUrl), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('successive URLs accumulate in the list — newest appears first',
        (tester) async {
      when(() => mockUseCase(tUrl))
          .thenAnswer((_) async => const Right(tAlias));
      when(() => mockUseCase(tUrl2))
          .thenAnswer((_) async => const Right(tAlias2));

      await tester.pumpWidget(buildSubject());

      await tester.enterText(find.byType(TextField), tUrl);
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), tUrl2);
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      final items = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(ListView),
              matching: find.byWidgetPredicate(
                (w) =>
                    w is Text &&
                    (w.data == tAlias.shortUrl || w.data == tAlias2.shortUrl),
              ),
            ),
          )
          .toList();

      expect(items.first.data, tAlias2.shortUrl);
      expect(items.last.data, tAlias.shortUrl);
    });
  });
}
