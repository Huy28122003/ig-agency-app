import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

class MediaEditTabletLayout extends StatelessWidget {
  const MediaEditTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: const Text('MediaPreviews')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.router.push(PinnedMessageRoute());
          },
          child: Text('Pinned Messages'),
        ),
      ),
    );
  }
}
