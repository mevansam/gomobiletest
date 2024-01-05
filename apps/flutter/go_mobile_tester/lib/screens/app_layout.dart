import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_mobile_tester/main.dart';

class AppLayout extends StatelessWidget {
  final Widget? body;
  final bool isWaiting;

  const AppLayout({super.key, this.body, this.isWaiting = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (Platform.isMacOS) {
        // On macOS a system menu is a required part of every application
        final List<PlatformMenuItem> menus = <PlatformMenuItem>[
          PlatformMenu(
            label: '', // In macOS the application name is shown in the menu bar
            menus: <PlatformMenuItem>[
              PlatformMenuItemGroup(
                members: <PlatformMenuItem>[
                  PlatformMenuItem(
                    label: 'About',
                    onSelected: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'GO Mobile Tester',
                        applicationVersion: '0.0.1',
                      );
                    },
                  ),
                ],
              ),
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.quit))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.quit),
            ],
          ),
        ];
        WidgetsBinding.instance.platformMenuDelegate.setMenus(menus);
      }

      var showImage = !Main.isMobile && constraints.maxWidth > 600;

      return Stack(
        children: [
          Scaffold(
            appBar: Main.isMobile
                ? AppBar(
                    title: const Text(Main.title),
                  )
                : null,
            body: Row(
              children: [
                if (showImage) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/gophers-doing-experiments.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ],
                Container(
                  width: showImage
                      ? max(constraints.maxWidth / 3, 350)
                      : constraints.maxWidth,
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: body,
                ),
              ],
            ),
          ),

          // Show a modal progress indicator when waiting.
          if (isWaiting) ...[
            const Opacity(
              opacity: 0.8,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      );
    });
  }
}
