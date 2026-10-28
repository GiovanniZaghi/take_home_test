import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_test/domain/domain.dart';
import 'package:take_home_test/presentation/cubit/take_home_state.dart';

class TakeHomeCubit extends Cubit<TakeHomeState> {
  TakeHomeCubit(this._createAliasUseCase) : super(const TakeHomeInitial());

  final CreateAliasUseCase _createAliasUseCase;

  final List<AliasEntity> _history = [];

  Future<void> shortenUrl(String url) async {
    emit(TakeHomeLoading(List.unmodifiable(_history)));

    final result = await _createAliasUseCase(url);

    result.fold(
      (failure) => emit(TakeHomeError(
        message: failure.message,
        aliases: List.unmodifiable(_history),
      )),
      (alias) {
        _history.insert(0, alias);
        emit(TakeHomeLoaded(List.unmodifiable(_history)));
      },
    );
  }
}
