import 'package:flutter_modular/flutter_modular.dart';
import 'package:take_home_test/take_home_binds.dart';
import 'package:take_home_test/take_home_routes.dart';

class TakeHomeModule extends Module {
  @override
  void binds(Injector i) => TakeHomeBinds.register(i);

  @override
  void routes(RouteManager r) => TakeHomeRoutes.register(r);
}
