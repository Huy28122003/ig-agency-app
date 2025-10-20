import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/colors.dart';

class SelectImageModal extends StatelessWidget {
  const SelectImageModal({super.key});

  static Future<ImageSource?> show(BuildContext context) async {
    final result = await showCupertinoModalPopup<ImageSource?>(
      context: Navigator.of(context, rootNavigator: true).context,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      builder: (BuildContext context) => SelectImageModal(),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, ImageSource.camera);
          },
          child: Text(
            'Take a photo',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorsBlue,
              fontSize: 17,
              fontWeight: FontWeight.w400,
              height: 1.29,
              letterSpacing: -0.43,
            ),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, ImageSource.gallery);
          },
          child: Text(
            'Choose from library',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorsBlue,
              fontSize: 17,
              fontWeight: FontWeight.w400,
              height: 1.29,
              letterSpacing: -0.43,
            ),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
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
