import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/linked_device/linked_device_entity.dart';
import 'package:ig_agency_app/domain/entities/linked_device/log_recent_login_entity.dart';
import 'package:ig_agency_app/presentation/views/pages/setting/device_detail/device_detail_bloc.dart';
import 'package:ig_agency_app/shared/utils/date_time_util.dart';
import 'package:ig_agency_app/shared/utils/widget_util.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';

class DeviceDetailMobileLayout extends StatefulWidget {
  const DeviceDetailMobileLayout({super.key});

  @override
  State<DeviceDetailMobileLayout> createState() =>
      _DeviceDetailMobileLayoutState();
}

class _DeviceDetailMobileLayoutState extends State<DeviceDetailMobileLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeviceDetailBloc, DeviceDetailState>(
          listenWhen: (previous, current) {
            return previous.logoutSuccess != current.logoutSuccess;
          },
          listener: (context, state) {
            if (state.logoutSuccess) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Message'),
                  content: const Text('Logout device successful'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
          elevation: 0,
          toolbarHeight: 60,
          title: Text(
            'Device Details',
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
                const SizedBox(height: 25),
                Text(
                  'Recent logins',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDefaultTextDefault,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(child: _buildListRecentLogin()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentDevice() {
    return BlocSelector<
      DeviceDetailBloc,
      DeviceDetailState,
      LinkedDeviceEntity
    >(
      selector: (state) {
        return state.device;
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentDevice.address ?? '',
                            style: TextStyle(
                              color: AppColors.textDefaultTextDefault,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  currentDevice.date != null
                                      ? currentDevice.date!
                                            .formatDateTimeWithTimezone()
                                      : '',
                                  style: TextStyle(
                                    color: Color(0xFF6A7282),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (currentDevice.isThisDevice) ...[
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
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFFFFE2E2),
                                    foregroundColor: Color(0xFFFB2C36),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: Color(0xFFFFC9C9),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<DeviceDetailBloc>().add(
                                      LogoutEvent(),
                                    );
                                  },
                                  child: const Text(
                                    "Log Out",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFB2C36),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ].divide(const SizedBox(height: 10)),
        );
      },
    );
  }

  Widget _buildListRecentLogin() {
    return BlocSelector<
      DeviceDetailBloc,
      DeviceDetailState,
      List<LogRecentLoginEntity>
    >(
      selector: (state) {
        return state.listLog;
      },
      builder: (context, listLog) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final log = listLog[index];
            return _buildBlock(log: log);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: listLog.length,
        );
      },
    );
  }

  Widget _buildBlock({required LogRecentLoginEntity log}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFE5E7EB), width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.address ?? '',
                        style: TextStyle(
                          color: AppColors.textDefaultTextDefault,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        log.date != null
                            ? log.date!.formatDateTimeWithTimezone()
                            : '',
                        style: TextStyle(
                          color: Color(0xFF6A7282),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
