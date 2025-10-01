import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/pinned_message_list/bloc/pinned_message_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_list_view.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../widgets/pinned_message_bubble.dart';
import '../widgets/pinned_message_empty_view.dart';
import '../widgets/pinned_message_loading_item.dart';

class PinnedMessageListMobileLayout extends StatefulWidget {
  const PinnedMessageListMobileLayout({super.key});

  @override
  State<PinnedMessageListMobileLayout> createState() =>
      _PinnedMessageListMobileLayoutState();
}

class _PinnedMessageListMobileLayoutState
    extends State<PinnedMessageListMobileLayout> {
  late final PinnedMessageListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<PinnedMessageListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackgroundBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackgroundBackground,
        centerTitle: true,
        title: Text(
          'pinned_message_list.title'.tr(),
          style: TextStyle(
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            height: 28 / 22,
            color: AppColors.textDefaultTextDefault,
          ),
        ),
        leadingWidth: 52,
        leading: Container(
          padding: const EdgeInsets.only(left: 12),
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: EdgeInsets.all(8),
            onPressed: () {
              context.router.pop();
            },
            icon: Assets.icons.icArrowLeft.svg(
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.iconDefaultDefaultSub2,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<PinnedMessageListBloc, PinnedMessageListState>(
        buildWhen: (prev, curr) =>
            prev.isLoadedData != curr.isLoadedData ||
            prev.pagingStatus != curr.pagingStatus ||
            prev.pinnedMessages != curr.pinnedMessages,
        builder: (_, state) {
          if (state.isLoadedData && state.pinnedMessages.isEmpty) {
            return PinnedMessageEmptyView();
          } else {
            return AppListView(
              enablePullDown: false,
              onLoadMore: () {
                _bloc.add(LoadMorePinMessageInGroupEvent());
              },
              cardLoading: PinnedMessageLoadingItem(),
              numCardLoading: 6,
              fetchStatus: state.pagingStatus,
              data: state.pinnedMessages,
              builder: (_, index) {
                final message = state.pinnedMessages[index];

                return PinnedMessageBubble(
                  key: ValueKey(message.id),
                  message: message,
                  hasArrow: true,
                  onTap: () {
                    context.router.pop(message.id);
                  },
                  unpin: () {
                    final messageId = message.id;
                    if (messageId == null) return;
                    _bloc.add(UnpinMessageInGroupEvent(messageId: messageId));
                  },
                );
              },
              separatorBuilder: (_, _) => Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(
                  color: AppColors.outlineGrayStrong200,
                  height: 2,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
