import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:go_mobile_tester/app_state.dart';
import 'package:go_mobile_tester/app_layout.dart';
import 'package:go_mobile_tester/home_page.dart';
import 'package:go_mobile_tester/login_page.dart';

class AppAuth extends StatelessWidget {
  const AppAuth({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AppLayout(
          body: appState.isLoggedIn()
              ? HomePage(appState: appState)
              : LoginPage(appState: appState),
        ),
      ),
    );
  }
}
