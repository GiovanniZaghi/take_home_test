import 'package:flutter_modular/flutter_modular.dart';
import 'package:take_home_test/presentation/presentation.dart';

class TakeHomeRoutes {
  static void register(RouteManager r) {
    r.child('/', child: (context) => const TakeHomePage());
  }
}
