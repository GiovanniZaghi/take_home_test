import 'package:equatable/equatable.dart';

class GenericFailure extends Equatable {
  const GenericFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
