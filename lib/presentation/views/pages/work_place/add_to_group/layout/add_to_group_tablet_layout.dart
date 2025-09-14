import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

class AddToGroupTabletLayout extends StatefulWidget {
  const AddToGroupTabletLayout({super.key});

  @override
  State<AddToGroupTabletLayout> createState() => _AddToGroupTabletLayoutState();
}

class _AddToGroupTabletLayoutState extends State<AddToGroupTabletLayout> {
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
            // context.router.replaceAll([WSDetailRoute()]);
          },
        ),
      ),
    );
  }
}
