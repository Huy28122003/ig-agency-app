// import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// import 'package:ig_agency_app/presentation/routers/app_router.dart';

class CreateGroupTabletLayout extends StatefulWidget {
  const CreateGroupTabletLayout({super.key});

  @override
  State<CreateGroupTabletLayout> createState() =>
      _CreateGroupTabletLayoutState();
}

class _CreateGroupTabletLayoutState extends State<CreateGroupTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Text('TODO'),
          onTap: () {
            // context.router.replaceAll([
            //   WSDetailRoute(workspaceId: 1),
            // ]);
          },
        ),
      ),
    );
  }
}
