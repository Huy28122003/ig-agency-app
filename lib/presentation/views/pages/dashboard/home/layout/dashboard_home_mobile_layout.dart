import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_dashboard_type.dart';
import 'package:ig_agency_app/domain/entities/dashboard/overview_member_status.dart';
import 'package:ig_agency_app/shared/utils/widget_util.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/header_home_view.dart';
import '../dashboard_home_bloc.dart';
import '../widgets/notched_clipper.dart';

class DashboardHomeMobileLayout extends StatefulWidget {
  const DashboardHomeMobileLayout({super.key});

  @override
  State<DashboardHomeMobileLayout> createState() =>
      _DashboardHomeMobileLayoutState();
}

class _DashboardHomeMobileLayoutState extends State<DashboardHomeMobileLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardHomeBloc, DashboardHomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.surfaceContainerGrayStrong0,
          body: Column(
            children: [
              HeaderHomeView(
                title: 'dashboard.dashboard'.tr(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 30,
                ),
              ),
              Expanded(child: _buildBody(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(DashboardHomeState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewMember(state),
          const SizedBox(height: 20),
          Expanded(child: _buildListDashboardCard(state)),
        ],
      ),
    );
  }

  Widget _buildOverviewMember(DashboardHomeState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.outlineGrayStrong50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineGrayStrong200),
      ),
      child: Row(
        children: [
          // Left side
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "dashboard.total_member".tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6A7282),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${state.totalMember}',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFFFCB732),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFCB732),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "dashboard.details".tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Right side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.listOverviewMember
                  .map((e) => _statusBox(e.title, e.value, e.status.getColor()))
                  .toList()
                  .divide(const SizedBox(height: 8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListDashboardCard(DashboardHomeState state) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
      itemCount: state.listOverviewDashboard.length,
      itemBuilder: (context, index) {
        final item = state.listOverviewDashboard[index];
        return _buildDashboardCard(
          title: item.title,
          value: item.value,
          iconSvg: item.type.getIconWidget(),
        );
      },
    );
  }

  Widget _statusBox(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
      decoration: BoxDecoration(
        color: Color(0xFF1E2939),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF99A1AF),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required Widget iconSvg,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ClipPath(
          clipper: NotchedClipper(),
          child: Container(
            color: AppColors.surfaceContainerPrimaryPrimaryDisabled,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 46), // Để chừa chỗ cho Icon
                  Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E2939),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      value,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "dashboard.details".tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Icon nổi lên trên notch
        Positioned(top: -2, child: iconSvg),
      ],
    );
  }
}
