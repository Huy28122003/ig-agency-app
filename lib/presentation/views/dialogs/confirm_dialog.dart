import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.message,
    this.onConfirmBtnTap,
    this.onCancelBtnTap,
  });

  final String message;
  final VoidCallback? onConfirmBtnTap;
  final VoidCallback? onCancelBtnTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(message, textAlign: TextAlign.center)],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          height: 36,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirmBtnTap?.call();
                  },
                  child: Text('Yes'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancelBtnTap?.call();
                  },
                  child: Text('No'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
