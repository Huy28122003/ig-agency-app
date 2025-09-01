import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/pinned_message_tablet_layout.dart';
import 'layout/pinned_message_mobile_layout.dart';
import 'pinned_message_bloc.dart';

@RoutePage()
class PinnedMessagePage
    extends
        BasePage<PinnedMessageBloc, PinnedMessageEvent, PinnedMessageState> {
  const PinnedMessagePage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<PinnedMessageBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return PinnedMessageMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return PinnedMessageTabletLayout();
  }
}
