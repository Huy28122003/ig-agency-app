import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../edit_bio_bloc.dart';

class EditBioTabletLayout extends StatefulWidget {
  const EditBioTabletLayout({super.key});

  @override
  State<EditBioTabletLayout> createState() => _EditBioTabletLayoutState();
}

class _EditBioTabletLayoutState extends State<EditBioTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditBioBloc, EditBioState>(
      listener: (context, state) {
        if (state.isSaveSuccess) {
          context.router.pop();
        }
      },
      child: SizedBox(),
    );
  }
}
