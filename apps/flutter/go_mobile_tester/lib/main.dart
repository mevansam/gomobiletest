import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:go_mobile_tester/app_state.dart';
import 'package:go_mobile_tester/app_auth.dart';

void main() async {
  // On Desktop platforms the minimum size
  // of the window is fixed at 240x400
  if (!Main.isMobile) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowManager.instance.setMinimumSize(const Size(240, 400));
    WindowManager.instance.setTitle(Main.title);
  }

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  static const String title = 'GO Mobile Tester';
  static var isMobile = Platform.isAndroid || Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          title: title,
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: const AppAuth(),
        ));
  }
}
