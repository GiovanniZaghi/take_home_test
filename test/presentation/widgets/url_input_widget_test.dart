import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:take_home_test/presentation/widgets/url_input_widget.dart';

Widget _buildSubject({
  required void Function(String) onSubmit,
  bool isLoading = false,
}) {
  return MaterialApp(
    home: Scaffold(
      body: UrlInputWidget(isLoading: isLoading, onSubmit: onSubmit),
    ),
  );
}

void main() {
  group('UrlInputWidget', () {
    testWidgets('renders TextField and send button when not loading',
        (tester) async {
      await tester.pumpWidget(_buildSubject(onSubmit: (_) {}));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows CircularProgressIndicator and hides arrow when loading',
        (tester) async {
      await tester.pumpWidget(
        _buildSubject(onSubmit: (_) {}, isLoading: true),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsNothing);
    });

    testWidgets('calls onSubmit with trimmed URL on button tap', (tester) async {
      String? submitted;

      await tester.pumpWidget(_buildSubject(onSubmit: (url) => submitted = url));

      await tester.enterText(
          find.byType(TextField), '  https://google.com  ');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump();

      expect(submitted, 'https://google.com');
    });

    testWidgets('clears text field after submission', (tester) async {
      await tester.pumpWidget(_buildSubject(onSubmit: (_) {}));

      await tester.enterText(find.byType(TextField), 'https://google.com');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '');
    });

    testWidgets('does not call onSubmit when input is empty', (tester) async {
      bool called = false;

      await tester.pumpWidget(
        _buildSubject(onSubmit: (_) => called = true),
      );

      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump();

      expect(called, isFalse);
    });

    testWidgets('calls onSubmit on keyboard action send', (tester) async {
      String? submitted;

      await tester.pumpWidget(_buildSubject(onSubmit: (url) => submitted = url));

      await tester.enterText(find.byType(TextField), 'https://flutter.dev');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();

      expect(submitted, 'https://flutter.dev');
    });
  });
}
