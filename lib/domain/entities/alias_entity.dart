import 'package:equatable/equatable.dart';

class AliasEntity extends Equatable {
  const AliasEntity({
    required this.alias,
    required this.originalUrl,
    required this.shortUrl,
  });

  final String alias;
  final String originalUrl;
  final String shortUrl;

  @override
  List<Object?> get props => [alias, originalUrl, shortUrl];
}
