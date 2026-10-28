import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'take_home_module.dart';

void main() async {
  await dotenv.load();
  runApp(ModularApp(module: TakeHomeModule(), child: const AppWidget()));
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Take Home',
      routerConfig: Modular.routerConfig,
    );
  }
}
