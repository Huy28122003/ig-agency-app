import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../routers/app_router.dart';

class WorkspaceDetailMobileLayout extends StatelessWidget {
  const WorkspaceDetailMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text('Detail')),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            context.router.push(ChatInfoRoute());
          },
          child: Text('Detail'),
        ),
      ),
    );
  }
}
