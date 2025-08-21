import 'package:flutter/material.dart';

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
      backgroundColor: Colors.red,
      appBar: AppBar(title: const Text('Workspace')),
    );
  }
}
