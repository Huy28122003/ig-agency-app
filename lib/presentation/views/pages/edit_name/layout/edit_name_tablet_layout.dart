import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../edit_name_bloc.dart';

class EditNameTabletLayout extends StatefulWidget {
  const EditNameTabletLayout({super.key});

  @override
  State<EditNameTabletLayout> createState() => _EditNameTabletLayoutState();
}

class _EditNameTabletLayoutState extends State<EditNameTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNameBloc, EditNameState>(
      listener: (context, state) {
        if (state.isSaveSuccess) {
          context.router.pop();
        }
      },
      child: SizedBox(),
    );
  }
}
