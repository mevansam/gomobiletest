import 'package:flutter/material.dart';

import 'package:go_mobile_tester/app_state.dart';

class LoginPage extends StatelessWidget {
  final AppState? appState;
  const LoginPage({super.key, this.appState});

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameInput = TextEditingController();

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
                "Welcome back!\nSign in to continue!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            TextField(
              controller: userNameInput,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () => {
                    appState!.login(userNameInput.text),
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF265AE8),
                  ),
                  child: const Text(
                    "Login",
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
