import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

class WorkspaceListTabletLayout extends StatefulWidget {
  const WorkspaceListTabletLayout({super.key});

  @override
  State<WorkspaceListTabletLayout> createState() =>
      _WorkspaceListTabletLayoutState();
}

class _WorkspaceListTabletLayoutState extends State<WorkspaceListTabletLayout> {
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
            context.router.replaceAll([
              WSDetailRoute(workspaceId: 1, userId: '1'),
            ]);
          },
        ),
      ),
    );
  }
}
