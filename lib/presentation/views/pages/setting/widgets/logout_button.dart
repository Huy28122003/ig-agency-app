import 'package:flutter/widgets.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onLogout,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerAlertErrorLight,
          border: Border.all(color: AppColors.outlineAlertErrorLight, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 32,
          child: Row(
            children: [
              Assets.icons.icLogout.svg(width: 32, height: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.textAlertTextError,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
