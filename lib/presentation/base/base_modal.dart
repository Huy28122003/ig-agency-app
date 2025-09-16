import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/shared/utils/keyboard_utils.dart';

import '../../di/di.dart';
import 'base_bloc.dart';
import 'base_state.dart';

abstract class BaseModal<B extends BaseBloc<E, S>, E, S extends BaseState<S>>
    extends StatefulWidget
    implements AutoRouteWrapper {
  const BaseModal({super.key});

  Widget builder(BuildContext context);

  B get buildBloc => getIt<B>();

  void onInitState(BuildContext context) {}

  void onDispose(BuildContext context) {}

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<B>(create: (_) => buildBloc, child: this);
  }

  @override
  State<BaseModal> createState() => _BaseModalState<B, E, S>();
}

class _BaseModalState<B extends BaseBloc<E, S>, E, S extends BaseState<S>>
    extends State<BaseModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.onInitState(context);
    });
  }

  @override
  void dispose() {
    widget.onDispose(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        KeyboardUtils.hideKeyboard();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: widget.builder(context),
    );
  }
}
