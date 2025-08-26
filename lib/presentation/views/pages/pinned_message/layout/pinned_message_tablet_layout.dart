import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class PinnedMessageTabletLayout extends StatefulWidget {
  const PinnedMessageTabletLayout({super.key});

  @override
  State<PinnedMessageTabletLayout> createState() =>
      _PinnedMessageTabletLayoutState();
}

class _PinnedMessageTabletLayoutState extends State<PinnedMessageTabletLayout> {
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
            context.router.pop();
          },
        ),
      ),
    );
  }
}
