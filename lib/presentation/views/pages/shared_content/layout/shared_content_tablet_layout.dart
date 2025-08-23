import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

class SharedContentTabletLayout extends StatefulWidget {
  const SharedContentTabletLayout({super.key});

  @override
  State<SharedContentTabletLayout> createState() =>
      _SharedContentTabletLayoutState();
}

class _SharedContentTabletLayoutState extends State<SharedContentTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Text('Shared'),
          onTap: () {
            context.router.replaceAll([LoginRoute()]);
          },
        ),
      ),
    );
  }
}
