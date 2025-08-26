import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../routers/app_router.dart';

class ChatInfoMobileLayout extends StatelessWidget {
  const ChatInfoMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Chat info')),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: IntrinsicHeight(
          child: Column(
            children: [
              GestureDetector(
                child: Text('Chat info'),
                onTap: () {
                  context.router.pop();
                },
              ),
              GestureDetector(
                child: Text('Shared content'),
                onTap: () {
                  context.router.push(SharedContentRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
