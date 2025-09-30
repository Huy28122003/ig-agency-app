import 'package:auto_route/auto_route.dart';
import 'package:card_loading/card_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/pages/pinned_message_list/bloc/pinned_message_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/ui_models/pinned_message_ui_model.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_list_view.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../widgets/pinned_message_bubble.dart';

class PinnedMessageListMobileLayout extends StatefulWidget {
  const PinnedMessageListMobileLayout({super.key});

  @override
  State<PinnedMessageListMobileLayout> createState() =>
      _PinnedMessageListMobileLayoutState();
}

class _PinnedMessageListMobileLayoutState
    extends State<PinnedMessageListMobileLayout> {
  late final PinnedMessageListBloc _pinnedMessageListBloc;

  @override
  void initState() {
    super.initState();
    _pinnedMessageListBloc = context.read<PinnedMessageListBloc>();
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
            prev.pagingStatus != curr.pagingStatus ||
            prev.pinnedMessages != curr.pinnedMessages,
        builder: (_, state) {
          if (state.pinnedMessages.isEmpty) {
            return _buildEmpty();
          } else {
            return AppListView(
              enablePullDown: false,
              onLoadMore: () {
                _pinnedMessageListBloc.add(FetchDataEvent());
              },
              cardLoading: _buildLoading(),
              numCardLoading: 6,
              fetchStatus: state.pagingStatus,
              data: state.pinnedMessages,
              builder: (_, index) {
                final message = state.pinnedMessages[index];

                return PinnedMessageBubble(
                  key: ValueKey(message.id),
                  message: message.toUIModel(),
                  hasArrow: true,
                  onTap: () {
                    context.router.push(
                      WSDetailRoute(
                        groupId: _pinnedMessageListBloc.groupId,
                        groupName: _pinnedMessageListBloc.groupName,
                        groupAvatar: _pinnedMessageListBloc.groupAvatar,
                      ),
                    );
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

  Widget _buildEmpty() {
    return Column(
      children: [
        Spacer(),
        Assets.images.imgPinnedEmpty.image(width: 160, height: 160),
        SizedBox(height: 10),
        Text(
          "pinned_mesage_list.content".tr(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            height: 28 / 24,
            fontFamily: FontFamily.segoeUI,
            color: AppColors.textDefaultTextDefault,
          ),
        ),
        Text(
          "pinned_mesage_list.description".tr(),
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 28 / 16,
            fontFamily: FontFamily.segoeUI,
            color: AppColors.textDefaultTextSub2,
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardLoading(
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                width: 48,
                margin: EdgeInsets.only(bottom: 10),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CardLoading(
                  height: 100,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
