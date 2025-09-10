import 'package:flutter/material.dart';

enum OverviewMemberStatus { accept, online, block }

extension OverviewMemberStatusExtension on OverviewMemberStatus {
  String getTitle() {
    switch (this) {
      case OverviewMemberStatus.accept:
        return 'Accept';
      case OverviewMemberStatus.online:
        return 'Online';
      case OverviewMemberStatus.block:
        return 'Block';
    }
  }

  Color getColor() {
    switch (this) {
      case OverviewMemberStatus.accept:
        return Colors.white;
      case OverviewMemberStatus.online:
        return const Color(0xFF00C950);
      case OverviewMemberStatus.block:
        return const Color(0xFFFB2C36);
    }
  }
}
