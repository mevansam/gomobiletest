import 'package:flutter/material.dart';

import 'package:go_mobile_tester/state/app_state.dart';
import 'package:go_mobile_tester/services/greeter_service.dart';
import 'package:go_mobile_tester/utility/message.dart';
import 'package:go_mobile_tester/utility/error.dart';
import 'package:go_mobile_tester/screens/profile_view.dart';

class HomePage extends StatelessWidget {
  final AppState appState;

  const HomePage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (!appState.greeted) {
        var greeterService = GreeterService(MessageDialog('Hello', context));
        greeterService
            .greet(appState.loggedInPerson)
            .whenComplete(() => appState.greetingShown())
            .onError(
                (error, stackTrace) => showError(context, error.toString()));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.menu),
              );
            },
            menuChildren: [
              MenuItemButton(
                leadingIcon: const Icon(Icons.logout),
                child: const Text('Logout'),
                onPressed: () => appState.logout(),
              ),
            ],
          ),
        ],
      ),
      body: ProfileView(appState: appState),
    );
  }
}
