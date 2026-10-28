import 'package:flutter_test/flutter_test.dart';
import 'package:take_home_test/domain/entities/entities.dart';

void main() {
  const tEntity = AliasEntity(
    alias: 'abc123',
    originalUrl: 'https://google.com',
    shortUrl: 'https://short.io/abc123',
  );

  group('AliasEntity', () {
    test('props contains all fields', () {
      expect(tEntity.props, [
        'abc123',
        'https://google.com',
        'https://short.io/abc123',
      ]);
    });

    test('two instances with same values are equal', () {
      const other = AliasEntity(
        alias: 'abc123',
        originalUrl: 'https://google.com',
        shortUrl: 'https://short.io/abc123',
      );
      expect(tEntity, equals(other));
    });

    test('two instances with different alias are not equal', () {
      const other = AliasEntity(
        alias: 'xyz',
        originalUrl: 'https://google.com',
        shortUrl: 'https://short.io/abc123',
      );
      expect(tEntity, isNot(equals(other)));
    });
  });
}
