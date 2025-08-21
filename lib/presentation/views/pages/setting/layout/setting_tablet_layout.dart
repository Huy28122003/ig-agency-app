import 'package:flutter/material.dart';

class SettingTabletLayout extends StatefulWidget {
  const SettingTabletLayout({super.key});

  @override
  State<SettingTabletLayout> createState() => _SettingTabletLayoutState();
}

class _SettingTabletLayoutState extends State<SettingTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text('Settings')),
    );
  }
}
