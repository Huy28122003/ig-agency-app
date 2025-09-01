import 'package:flutter/widgets.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key, required this.onDeleteAccount});

  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDeleteAccount,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerAlertErrorLight,
          border: Border.all(color: AppColors.outlineAlertErrorLight, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 24,
          child: Row(
            children: [
              Assets.icons.icProfileDelete.svg(width: 24, height: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delete Account',
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
