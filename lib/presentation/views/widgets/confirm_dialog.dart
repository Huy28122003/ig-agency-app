import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../gen/fonts.gen.dart';
import '../../resources/colors.dart';
import 'app_button.dart';

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    this.description,
    required this.okText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.cancelTextStyle,
    this.okTextStyle,
  });

  final String title;
  final String? description;
  final String okText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final TextStyle? cancelTextStyle;
  final TextStyle? okTextStyle;

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();

  static Future<bool?> show(
    BuildContext context, {
    String? icon,
    required String title,
    String? description,
    Widget? descriptionWidget,
    required String okText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    TextStyle? okTextStyle,
    TextStyle? cancelTextStyle,
  }) {
    return showDialog<bool?>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => ConfirmDialog(
        title: title,
        description: description,
        okText: okText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        cancelTextStyle: cancelTextStyle,
        okTextStyle: okTextStyle,
      ),
    );
  }
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {},
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Color(0xFFD0D0D0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 19),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 22,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.description != null) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    widget.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textDefaultTextSub,
                      fontSize: 14,
                      fontFamily: FontFamily.segoeUI,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
                const SizedBox(height: 17.0),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Color(0xFF808080).withValues(alpha: 0.55),
                ),
                Row(
                  children: [
                    if (widget.cancelText != null) ...[
                      Expanded(
                        child: AppButton.text(
                          onPressed: () {
                            context.router.pop(false);
                            widget.onCancel?.call();
                          },
                          child: Text(
                            widget.cancelText!,
                            style:
                                widget.cancelTextStyle ??
                                TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  height: 22 / 17,
                                  color: Color(0xFF007AFF),
                                ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: Color(0xFF808080).withValues(alpha: 0.55),
                      ),
                      Expanded(
                        child: AppButton.text(
                          onPressed: () {
                            context.router.pop(true);
                            widget.onConfirm?.call();
                          },
                          child: Text(
                            widget.okText,
                            style:
                                widget.okTextStyle ??
                                TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  height: 22 / 17,
                                  color: Color(0xFFFB2C36),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
