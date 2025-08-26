import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../routers/app_router.dart';

class SettingHomeMobileLayout extends StatelessWidget {
  const SettingHomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: const Text('SettingHomes')),
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
