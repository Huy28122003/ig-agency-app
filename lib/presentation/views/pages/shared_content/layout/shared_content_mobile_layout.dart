import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class SharedContentMobileLayout extends StatelessWidget {
  const SharedContentMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shared')),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Text('Shared'),
          onTap: () {
            context.router.pop();
          },
        ),
      ),
    );
  }
}
