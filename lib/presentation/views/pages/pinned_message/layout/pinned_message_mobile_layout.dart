import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../models/pinned_message_ui_model.dart';
import '../../../widgets/pinned_message_bubble.dart';
import '../pinned_message_bloc.dart';

class PinnedMessageMobileLayout extends StatelessWidget {
  const PinnedMessageMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle.light, // Light status bar
        backgroundColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
        elevation: 0,
        toolbarHeight: 60,
        title: Text(
          'Pinned Messages',
          style: TextStyle(
            color: AppColors.textDefaultTextInverted,
            fontSize: 22,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w700,
            height: 1.27,
          ),
        ),
        centerTitle: true,
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
                AppColors.iconDefaultDefaultInverted,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.outlineGrayStrong200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child:
              BlocSelector<
                PinnedMessageBloc,
                PinnedMessageState,
                List<PinnedMessageUIModel>
              >(
                selector: (state) {
                  return state.messages;
                },
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (context, index) =>
                        PinnedMessageBubble(message: state[index]),
                    separatorBuilder: (_, _) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(
                        color: AppColors.outlineGrayStrong200,
                        height: 2,
                      ),
                    ),
                    itemCount: state.length,
                  );
                },
              ),
        ),
      ),
    );
  }
}
