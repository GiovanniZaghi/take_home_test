import 'package:equatable/equatable.dart';
import 'package:take_home_test/domain/entities/entities.dart';

sealed class TakeHomeState extends Equatable {
  const TakeHomeState(this.aliases);

  final List<AliasEntity> aliases;
}

final class TakeHomeInitial extends TakeHomeState {
  const TakeHomeInitial() : super(const []);

  @override
  List<Object?> get props => [];
}

final class TakeHomeLoading extends TakeHomeState {
  const TakeHomeLoading(super.aliases);

  @override
  List<Object?> get props => [aliases];
}

final class TakeHomeLoaded extends TakeHomeState {
  const TakeHomeLoaded(super.aliases);

  @override
  List<Object?> get props => [aliases];
}

final class TakeHomeError extends TakeHomeState {
  const TakeHomeError({required this.message, required List<AliasEntity> aliases})
      : super(aliases);

  final String message;

  @override
  List<Object?> get props => [message, aliases];
}
