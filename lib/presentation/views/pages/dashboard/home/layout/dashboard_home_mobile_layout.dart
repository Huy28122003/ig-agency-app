import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/assets.gen.dart';
import 'package:ig_agency_app/presentation/views/pages/dashboard/home/widgets/notched_clipper.dart';
import '../../../../widgets/header_home_view.dart';

class DashboardHomeMobileLayout extends StatefulWidget {
  const DashboardHomeMobileLayout({super.key});

  @override
  State<DashboardHomeMobileLayout> createState() => _DashboardHomeMobileLayoutState();
}

class _DashboardHomeMobileLayoutState extends State<DashboardHomeMobileLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderHomeView(title: 'Dashboard', padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30)),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewMember(),
          const SizedBox(height: 20),
          Expanded(child: _buildListDashboardCard()),
        ],
      ),
    );
  }

  Widget _buildOverviewMember() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
        // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          // Left side
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Total Members",
                    style: TextStyle(fontSize: 16, color: Color(0xFF6A7282), fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "299199",
                    style: TextStyle(fontSize: 28, color: Color(0xFFFCB732), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFCB732),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Details",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
              children: [
                _statusBox("Accept", "299199", Colors.white, Colors.black87),
                const SizedBox(height: 8),
                _statusBox("Online", "153469", Colors.green, Colors.black87),
                const SizedBox(height: 8),
                _statusBox("Block", "299", Colors.red, Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListDashboardCard() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        _buildDashboardCard(title: 'All Violations', value: '999', iconSvg: Assets.icons.icViolation.svg()),
        _buildDashboardCard(title: 'All Devices', value: '999', iconSvg: Assets.icons.icDevice.svg()),
        _buildDashboardCard(title: 'Total Visits', value: '999999', iconSvg: Assets.icons.icView.svg()),
        _buildDashboardCard(title: 'Total Messages', value: '999', iconSvg: Assets.icons.icMessage.svg()),
      ],
    );
  }

  Widget _statusBox(String title, String value, Color valueColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFF99A1AF), fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({required String title, required String value, required Widget iconSvg}) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ClipPath(
          clipper: NotchedClipper(),
          child: Container(
            color: Color(0xFFFEE2AD),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 46), // Để chừa chỗ cho Icon
                  Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(fontSize: 14, color: Color(0xFF1E2939), fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(value, maxLines: 1, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 16),
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
