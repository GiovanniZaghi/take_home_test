import 'package:flutter_test/flutter_test.dart';
import 'package:take_home_test/domain/failure/failure.dart';

void main() {
  group('GenericFailure', () {
    test('stores message correctly', () {
      const failure = GenericFailure('something went wrong');
      expect(failure.message, 'something went wrong');
    });

    test('props contains message', () {
      const failure = GenericFailure('error');
      expect(failure.props, ['error']);
    });

    test('two instances with same message are equal', () {
      const a = GenericFailure('error');
      const b = GenericFailure('error');
      expect(a, equals(b));
    });

    test('two instances with different messages are not equal', () {
      const a = GenericFailure('error 1');
      const b = GenericFailure('error 2');
      expect(a, isNot(equals(b)));
    });
  });
}
