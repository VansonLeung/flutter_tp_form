import 'package:flutter/material.dart';

import 'GenericDecorationBackground.dart';

class GenericScaffold extends StatelessWidget {
  final String? titleString;
  final Widget? body;
  final Widget? bottomNavigationBar;

  const GenericScaffold({super.key, this.titleString, this.body, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF10062c),
          title: Text(titleString ?? ""),
        ),
        body: Container(
          decoration: GenericDecorationBackground.Dark,
          child: body
        ),
        bottomNavigationBar: bottomNavigationBar,
    );
  }
}
