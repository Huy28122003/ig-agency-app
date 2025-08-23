import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../routers/app_router.dart';

class WorkspaceListMobileLayout extends StatelessWidget {
  const WorkspaceListMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Text('List'),
          onTap: () {
            context.router.push(WSDetailRoute());
          },
        ),
      ),
    );
  }
}
