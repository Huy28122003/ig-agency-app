import 'package:flutter/material.dart';

class WorkspaceDetailTabletLayout extends StatefulWidget {
  const WorkspaceDetailTabletLayout({super.key});

  @override
  State<WorkspaceDetailTabletLayout> createState() =>
      _WorkspaceDetailTabletLayoutState();
}

class _WorkspaceDetailTabletLayoutState
    extends State<WorkspaceDetailTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WorkspaceDetail')),
      body: Container(height: 200),
    );
  }
}
