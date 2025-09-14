import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../presentation/resources/colors.dart';

class AppCheckBox extends StatelessWidget {
  const AppCheckBox({
    this.padding = const EdgeInsets.all(0),
    this.title,
    this.value = false,
    this.size = 24,
    this.enable = true,
    this.onChanged,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final String? title;
  final bool value;
  final double size;
  final bool enable;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enable ? () => onChanged?.call(value) : null,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size,
              width: size,
              child: value
                  ? Assets.icons.icChecked.svg()
                  : Assets.icons.icUncheck.svg(),
            ),
            if (title != null) Expanded(child: _getTitle(context)),
          ],
        ),
      ),
    );
  }

  Widget _getTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title ?? '',
        style: TextStyle(fontSize: 16, color: AppColors.textDefaultTextDefault),
      ),
    );
  }
}
