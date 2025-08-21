import 'package:flutter/material.dart';

class WorkspaceDetailMobileLayout extends StatefulWidget {
  const WorkspaceDetailMobileLayout({super.key});

  @override
  State<WorkspaceDetailMobileLayout> createState() =>
      _WorkspaceDetailMobileLayoutState();
}

class _WorkspaceDetailMobileLayoutState
    extends State<WorkspaceDetailMobileLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WorkspaceDetail')),
      body: Container(
        height: 200,
      ),
    );
  }
}
