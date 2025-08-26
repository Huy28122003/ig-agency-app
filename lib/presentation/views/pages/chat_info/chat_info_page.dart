import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/chat_info_tablet_layout.dart';
import 'layout/chat_info_mobile_layout.dart';
import 'chat_info_bloc.dart';

@RoutePage()
class ChatInfoPage
    extends
        BasePage<ChatInfoBloc, ChatInfoEvent, ChatInfoState> {
  const ChatInfoPage({super.key});

  @override
  void onInitState(BuildContext context) {
    context.read<ChatInfoBloc>().add(LoadDataEvent());
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return ChatInfoMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return ChatInfoTabletLayout();
  }
}
