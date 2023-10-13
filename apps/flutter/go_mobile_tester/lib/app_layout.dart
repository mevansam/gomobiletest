import 'package:flutter/material.dart';
import 'package:go_mobile_tester/main.dart';

class AppLayout extends StatelessWidget {
  final Widget? body;

  const AppLayout({super.key, this.body});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var showImage = !Main.isMobile && constraints.maxWidth > 600;

      return Scaffold(
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
              width:
                  showImage ? constraints.maxWidth / 3 : constraints.maxWidth,
              constraints: const BoxConstraints(maxWidth: 600),
              child: body,
            ),
          ],
        ),
      );
    });
  }
}
