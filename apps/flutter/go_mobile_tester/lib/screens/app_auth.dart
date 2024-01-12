import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:go_mobile_tester/state/app_state.dart';
import 'package:go_mobile_tester/screens/app_layout.dart';
import 'package:go_mobile_tester/screens/home_page.dart';
import 'package:go_mobile_tester/screens/login_page.dart';

class AppAuth extends StatelessWidget {
  const AppAuth({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: AppLayout(
        body: appState.isLoggedIn
            ? HomePage(appState: appState)
            : LoginPage(appState: appState),
        isWaiting: appState.isWaiting,
      ),
    );
  }
}
