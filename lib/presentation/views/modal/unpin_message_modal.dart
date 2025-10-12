import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class UnpinMessageModal extends StatelessWidget {
  const UnpinMessageModal({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showCupertinoModalPopup<bool>(
      context: Navigator.of(context, rootNavigator: true).context,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      builder: (BuildContext context) => UnpinMessageModal(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            'Unpin',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorsBlue,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.29,
              letterSpacing: -0.43,
            ),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context, false);
        },
        child: Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.colorsBlue,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            height: 1.29,
            letterSpacing: -0.43,
          ),
        ),
      ),
    );
  }
}
