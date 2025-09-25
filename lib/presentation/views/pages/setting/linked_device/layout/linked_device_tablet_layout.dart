import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/linked_device/linked_device_type.dart';
import 'package:ig_agency_app/shared/utils/widget_util.dart';

import '../../../../../../domain/entities/linked_device/linked_device_entity.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../linked_device_bloc.dart';

class LinkedDeviceTabletLayout extends StatefulWidget {
  const LinkedDeviceTabletLayout({super.key});

  @override
  State<LinkedDeviceTabletLayout> createState() =>
      _LinkedDeviceTabletLayoutState();
}

class _LinkedDeviceTabletLayoutState extends State<LinkedDeviceTabletLayout> {
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
          'Linked Devices',
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
        actions: [
          InkWell(
            onTap: () {
              context.router.push(const LoginHistoryRoute());
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 5),
              child: Text(
                'Select All',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Other devices',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDefaultTextDefault,
                    ),
                  ),
                  Text(
                    'Select devices',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00BBA7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(child: _buildOtherDevice()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentDevice() {
    return BlocSelector<
      LinkedDeviceBloc,
      LinkedDeviceState,
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
              'Current Devices',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDefaultTextDefault,
              ),
            ),
            _buildBlock(
              device: currentDevice,
              onTap: () {
                context.router.push(DeviceDetailRoute(device: currentDevice));
              },
            ),
          ].divide(const SizedBox(height: 10)),
        );
      },
    );
  }

  Widget _buildOtherDevice() {
    return BlocSelector<
      LinkedDeviceBloc,
      LinkedDeviceState,
      List<LinkedDeviceEntity>
    >(
      selector: (state) {
        return state.listDevice;
      },
      builder: (context, listDevice) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final device = listDevice[index];
            return _buildBlock(
              device: device,
              onTap: () {
                context.router.push(DeviceDetailRoute(device: device));
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: listDevice.length,
        );
      },
    );
  }

  Widget _buildBlock({
    required LinkedDeviceEntity device,
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
                  Assets.icons.icArrowRight.svg(
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      Color(0xFF99A1AF),
                      BlendMode.srcIn,
                    ),
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
}
