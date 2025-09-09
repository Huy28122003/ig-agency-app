import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';

class MenuDialog<T> extends StatefulWidget {
  final String title;
  final String? textCancel;
  final List<MenuItem<T>> items;
  final ValueChanged<T> onTap;

  const MenuDialog({
    super.key,
    required this.title,
    required this.items,
    this.textCancel,
    required this.onTap,
  });

  static Future<void> show<T>({
    required BuildContext context,
    required String title,
    String? textCancel,
    required List<MenuItem<T>> items,
    required ValueChanged<T> onTap,
  }) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MenuDialog<T>(
          title: title,
          items: items,
          textCancel: textCancel,
          onTap: onTap,
        );
      },
    );
  }

  @override
  State<MenuDialog<T>> createState() => _MenuDialogState<T>();
}

class _MenuDialogState<T> extends State<MenuDialog<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 70),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 11),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    fontFamily: FontFamily.segoeUI,
                    height: 22 / 17,
                    color: AppColors.textDefaultTextDefault,
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Color(0xFF808080).withValues(alpha: 0.55),
              ),
              for (int i = 0; i < widget.items.length; i++) ...[
                _buildItem(widget.items[i]),
                if (i != widget.items.length - 1)
                  Container(
                    height: 1,
                    color: Color(0xFF808080).withValues(alpha: 0.55),
                  ),
              ],
              Container(
                height: 1,
                color: Color(0xFF808080).withValues(alpha: 0.55),
              ),
              AppButton.text(
                onPressed: () {
                  context.router.pop();
                },
                child: Text(
                  widget.textCancel ?? "general.cancel".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    fontFamily: FontFamily.segoeUI,
                    height: 22 / 17,
                    color: Color(0xFF2B7FFF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(MenuItem<T> item) {
    return GestureDetector(
      onTap: () {
        context.router.pop();
        widget.onTap(item.value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11),
        child: Text(
          item.content,
          style:
              item.contentStyle ??
              TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.segoeUI,
                fontSize: 17,
                color: Color(0xFF007AFF),
              ),
        ),
      ),
    );
  }
}

class MenuItem<T> {
  final String content;
  final TextStyle? contentStyle;
  final T value;

  MenuItem({required this.content, this.contentStyle, required this.value});
}
