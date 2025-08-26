import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

class WorkspaceDetailTabletLayout extends StatelessWidget {
  const WorkspaceDetailTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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
