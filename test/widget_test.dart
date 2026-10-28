import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:take_home_test/domain/entities/entities.dart';
import 'package:take_home_test/presentation/widgets/alias_list_item_widget.dart';

void main() {
  const tEntity = AliasEntity(
    alias: 'abc123',
    originalUrl: 'https://google.com',
    shortUrl: 'https://short.io/abc123',
  );

  Widget buildSubject() => const MaterialApp(
        home: Scaffold(body: AliasListItemWidget(alias: tEntity)),
      );

  void mockClipboard(WidgetTester tester, {void Function(String text)? onSet}) {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          onSet?.call((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
  }

  group('AliasListItemWidget', () {
    testWidgets('renders shortUrl and originalUrl', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text(tEntity.shortUrl), findsOneWidget);
      expect(find.text(tEntity.originalUrl), findsOneWidget);
    });

    testWidgets('renders divider', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('is wrapped in InkWell for tap feedback', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('copies shortUrl to clipboard on tap', (tester) async {
      String? copiedText;
      mockClipboard(tester, onSet: (text) => copiedText = text);

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(copiedText, tEntity.shortUrl);
    });

    testWidgets('shows SnackBar with confirmation after tap', (tester) async {
      mockClipboard(tester);

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Short URL copied!'), findsOneWidget);
    });
  });
}
