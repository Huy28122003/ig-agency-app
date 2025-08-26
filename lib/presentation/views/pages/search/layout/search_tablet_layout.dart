import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

class SearchTabletLayout extends StatefulWidget {
  const SearchTabletLayout({super.key});

  @override
  State<SearchTabletLayout> createState() => _SearchTabletLayoutState();
}

class _SearchTabletLayoutState extends State<SearchTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            context.router.replaceAll([WSDetailRoute()]);
          },
          child: const Text('Search'),
        ),
      ),
    );
  }
}
