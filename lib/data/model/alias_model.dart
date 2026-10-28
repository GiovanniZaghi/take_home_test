import 'package:equatable/equatable.dart';
import 'package:take_home_test/domain/entities/entities.dart';

class AliasModel extends Equatable {
  const AliasModel({
    required this.alias,
    required this.originalUrl,
    required this.shortUrl,
  });

  final String alias;
  final String originalUrl;
  final String shortUrl;

  factory AliasModel.fromJson(Map<String, dynamic> json) {
    final links = json['_links'] as Map<String, dynamic>;
    return AliasModel(
      alias: json['alias'] as String,
      originalUrl: links['self'] as String,
      shortUrl: links['short'] as String,
    );
  }

  AliasEntity toEntity() => AliasEntity(
        alias: alias,
        originalUrl: originalUrl,
        shortUrl: shortUrl,
      );

  @override
  List<Object?> get props => [alias, originalUrl, shortUrl];
}
