import 'package:flutter_test/flutter_test.dart';
import 'package:take_home_test/data/model/model.dart';
import 'package:take_home_test/domain/entities/entities.dart';

void main() {
  const tJson = {
    'alias': 'abc123',
    '_links': {
      'self': 'https://google.com',
      'short': 'https://url.short/abc123',
    },
  };

  const tModel = AliasModel(
    alias: 'abc123',
    originalUrl: 'https://google.com',
    shortUrl: 'https://url.short/abc123',
  );

  group('AliasModel', () {
    group('fromJson', () {
      test('parses alias from root key', () {
        expect(AliasModel.fromJson(tJson).alias, 'abc123');
      });

      test('parses originalUrl from _links.self', () {
        expect(AliasModel.fromJson(tJson).originalUrl, 'https://google.com');
      });

      test('parses shortUrl from _links.short', () {
        expect(AliasModel.fromJson(tJson).shortUrl, 'https://url.short/abc123');
      });

      test('full parse produces expected model', () {
        expect(AliasModel.fromJson(tJson), tModel);
      });
    });

    group('toEntity', () {
      test('returns AliasEntity with identical field values', () {
        const expected = AliasEntity(
          alias: 'abc123',
          originalUrl: 'https://google.com',
          shortUrl: 'https://url.short/abc123',
        );
        expect(tModel.toEntity(), expected);
      });
    });

    group('Equatable', () {
      test('props contains all three fields', () {
        expect(tModel.props, [
          'abc123',
          'https://google.com',
          'https://url.short/abc123',
        ]);
      });

      test('two instances with same values are equal', () {
        const other = AliasModel(
          alias: 'abc123',
          originalUrl: 'https://google.com',
          shortUrl: 'https://url.short/abc123',
        );
        expect(tModel, equals(other));
      });

      test('two instances with different alias are not equal', () {
        const other = AliasModel(
          alias: 'different',
          originalUrl: 'https://google.com',
          shortUrl: 'https://url.short/abc123',
        );
        expect(tModel, isNot(equals(other)));
      });
    });
  });
}
