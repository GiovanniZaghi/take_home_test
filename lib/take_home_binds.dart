import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:take_home_test/data/data.dart';
import 'package:take_home_test/domain/domain.dart';
import 'package:take_home_test/presentation/cubit/cubit.dart';

class TakeHomeBinds {
  static void register(Injector i) {
    _httpBinds(i);
    _datasourceBinds(i);
    _repositoryBinds(i);
    _useCaseBinds(i);
    _cubitBinds(i);
  }

  static void _httpBinds(Injector i) {
    i.addSingleton<Dio>(HttpClient.create);
    i.addSingleton<Networking>(
      () => NetworkingImpl(i.get<Dio>()),
    );
  }

  static void _datasourceBinds(Injector i) {
    i.add<TakeHomeDatasource>(
      () => TakeHomeDatasourceImpl(i.get<Networking>()),
    );
  }

  static void _repositoryBinds(Injector i) {
    i.add<TakeHomeRepository>(
      () => TakeHomeRepositoryImpl(i.get<TakeHomeDatasource>()),
    );
  }

  static void _useCaseBinds(Injector i) {
    i.add<CreateAliasUseCase>(
      () => CreateAliasUseCaseImpl(i.get<TakeHomeRepository>()),
    );
  }

  static void _cubitBinds(Injector i) {
    i.add<TakeHomeCubit>(
      () => TakeHomeCubit(i.get<CreateAliasUseCase>()),
    );
  }
}
