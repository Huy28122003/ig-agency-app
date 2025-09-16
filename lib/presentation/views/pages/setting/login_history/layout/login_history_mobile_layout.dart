import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/linked_device/linked_device_entity.dart';
import 'package:ig_agency_app/domain/entities/linked_device/linked_device_type.dart';
import 'package:ig_agency_app/presentation/views/pages/setting/login_history/login_history_bloc.dart';
import 'package:ig_agency_app/shared/utils/widget_util.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/app_checkbox.dart';

class LoginHistoryMobileLayout extends StatefulWidget {
  const LoginHistoryMobileLayout({super.key});

  @override
  State<LoginHistoryMobileLayout> createState() =>
      _LoginHistoryMobileLayoutState();
}

class _LoginHistoryMobileLayoutState extends State<LoginHistoryMobileLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
        elevation: 0,
        toolbarHeight: 60,
        title: Text(
          'Login History',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCurrentDevice(),
              const SizedBox(height: 30),
              _buildSectionTitle(),
              const SizedBox(height: 10),
              Expanded(child: _buildOtherDevice()),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return BlocSelector<
      LoginHistoryBloc,
      LoginHistoryState,
      List<LinkedDeviceEntity>
    >(
      selector: (state) {
        return state.listDeviceSelected;
      },
      builder: (context, listDeviceSelected) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${listDeviceSelected.length} Selected',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDefaultTextDefault,
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                context.read<LoginHistoryBloc>().add(SelectAllDeviceEvent());
              },
              child: Text(
                'Select all',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00BBA7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentDevice() {
    return BlocSelector<
      LoginHistoryBloc,
      LoginHistoryState,
      LinkedDeviceEntity
    >(
      selector: (state) {
        return state.currentDevice;
      },
      builder: (context, currentDevice) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logins on ${currentDevice.name ?? ''}',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDefaultTextDefault,
              ),
            ),
            Text(
              'Choose device you want to log out',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6A7282),
              ),
            ),
          ].divide(const SizedBox(height: 4)),
        );
      },
    );
  }

  Widget _buildOtherDevice() {
    return BlocSelector<
      LoginHistoryBloc,
      LoginHistoryState,
      (List<LinkedDeviceEntity>, List<LinkedDeviceEntity>)
    >(
      selector: (state) {
        return (state.listDevice, state.listDeviceSelected);
      },
      builder: (context, listDevice) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final device = listDevice.$1[index];
            final isSelected = listDevice.$2.contains(device);
            return _buildBlock(
              device: device,
              isSelected: isSelected,
              onTap: () {
                context.read<LoginHistoryBloc>().add(SelectDeviceEvent(device));
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: listDevice.$1.length,
        );
      },
    );
  }

  Widget _buildBlock({
    required LinkedDeviceEntity device,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  device.deviceType.getIcon,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name ?? '',
                          style: TextStyle(
                            color: AppColors.textDefaultTextDefault,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                device.address ?? '',
                                style: TextStyle(
                                  color: Color(0xFF6A7282),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (device.isThisDevice) ...[
                              const SizedBox(width: 6),
                              Text(
                                ' · This device',
                                style: TextStyle(
                                  color: Color(0xFF00BBA7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppCheckBox(
                    value: isSelected,
                    onChanged: (value) {
                      context.read<LoginHistoryBloc>().add(
                        SelectDeviceEvent(device),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return BlocSelector<
      LoginHistoryBloc,
      LoginHistoryState,
      List<LinkedDeviceEntity>
    >(
      selector: (state) {
        return state.listDeviceSelected;
      },
      builder: (context, listDeviceSelected) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFFFE2E2),
                    foregroundColor: listDeviceSelected.isEmpty
                        ? Color(0xFFFB2C36).withValues(alpha: 0.3)
                        : Color(0xFFFB2C36),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Color(0xFFFFC9C9), width: 1),
                    ),
                  ),
                  onPressed: () {
                    if (listDeviceSelected.isEmpty) return;
                    context.read<LoginHistoryBloc>().add(LogoutEvent());
                  },
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: listDeviceSelected.isEmpty
                          ? Color(0xFFFB2C36).withValues(alpha: 0.3)
                          : Color(0xFFFB2C36),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
