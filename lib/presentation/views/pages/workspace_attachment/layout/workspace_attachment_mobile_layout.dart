import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace_attachment/widgets/file_tab.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace_attachment/widgets/link_tab.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace_attachment/widgets/media_tab.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';

class WorkspaceAttachmentMobileLayout extends StatefulWidget {
  const WorkspaceAttachmentMobileLayout({super.key});

  @override
  State<WorkspaceAttachmentMobileLayout> createState() =>
      _WorkspaceAttachmentMobileLayoutState();
}

class _WorkspaceAttachmentMobileLayoutState
    extends State<WorkspaceAttachmentMobileLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = [
    "attachment.media".tr(),
    "attachment.file".tr(),
    "attachment.link".tr(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackgroundBackground,
      appBar: AppBar(
        leadingWidth: 52,
        leading: Container(
          padding: const EdgeInsets.only(left: 12),
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: const EdgeInsets.all(8),
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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'attachment.title'.tr(),
          style: TextStyle(
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            height: 28 / 22,
            color: AppColors.textDefaultTextDefault,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(tabs.length, (index) {
                final isSelected = _tabController.index == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _tabController.index = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.surfaceContainerPrimaryPrimaryDefault
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          fontSize: 14,
                          color: isSelected
                              ? AppColors.textDefaultTextInverted
                              : AppColors.textDefaultTextDefault,
                          height: 20 / 14,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [MediaTab(), FileTab(), LinkTab()],
            ),
          ),
        ],
      ),
    );
  }
}
