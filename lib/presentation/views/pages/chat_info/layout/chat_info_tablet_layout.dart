import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

class ChatInfoTabletLayout extends StatefulWidget {
  const ChatInfoTabletLayout({super.key});

  @override
  State<ChatInfoTabletLayout> createState() => _ChatInfoTabletLayoutState();
}

class _ChatInfoTabletLayoutState extends State<ChatInfoTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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
