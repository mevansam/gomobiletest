import 'package:flutter/material.dart';

import 'package:go_mobile_tester/utility/error.dart';
import 'package:go_mobile_tester/state/app_state.dart';
import 'package:go_mobile_tester/services/login_service.dart';

class LoginPage extends StatelessWidget {
  final AppState appState;
  const LoginPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameInput = TextEditingController();
    userNameInput.text = appState.username;

    void doLogin(String username) {
      var loginService = LoginService(appState, ErrorHandler(context));
      loginService
          .login(username)
          .onError((error, stackTrace) => showError(context, error.toString()));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            const Center(
              child: Text(
                'Welcome back!\nSign in to continue!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            TextFormField(
              onFieldSubmitted: (value) => doLogin(value),
              controller: userNameInput,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () => doLogin(userNameInput.text),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
