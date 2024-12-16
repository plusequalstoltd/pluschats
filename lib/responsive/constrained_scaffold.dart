import 'package:flutter/material.dart';

class ConstrainedScaffold extends StatelessWidget {
  final Color backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;

  const ConstrainedScaffold({
    super.key,
    this.backgroundColor = Colors.white,
    this.appBar,
    this.drawer,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: body,
        ),
      ),
    );
  }
}
