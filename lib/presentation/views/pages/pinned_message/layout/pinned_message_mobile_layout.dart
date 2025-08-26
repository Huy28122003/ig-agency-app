import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class PinnedMessageMobileLayout extends StatelessWidget {
  const PinnedMessageMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Text('Pinned'),
          onTap: () {
            context.router.root.pop();
          },
        ),
      ),
    );
  }
}
