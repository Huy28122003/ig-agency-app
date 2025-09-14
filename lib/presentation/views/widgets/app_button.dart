import 'package:flutter/material.dart';

import '../../resources/colors.dart';

enum AppButtonType { primary, outline, sub, small, icon, text, medium }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.type = AppButtonType.text,
    this.minimumSize,
    this.maximumSize,
    this.backgroundColor,
    this.foregroundColor,
    this.fixedSize,
    this.textStyle,
    this.shape,
    this.showUnderline = true,
    this.underLineColor,
  });

  const factory AppButton.primary({
    required VoidCallback? onPressed,
    required Widget child,
    Size? minimumSize,
    Size? maximumSize,
    Size? fixedSize,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    OutlinedBorder? shape,
  }) = _AppPrimaryButton;

  const factory AppButton.sub({
    required VoidCallback? onPressed,
    required Widget child,
    Size? minimumSize,
    Size? maximumSize,
    Size? fixedSize,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    OutlinedBorder? shape,
  }) = _AppSubButton;

  const factory AppButton.small({
    required VoidCallback? onPressed,
    required Widget child,
    Size? maximumSize,
    Size? fixedSize,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    OutlinedBorder? shape,
    Size? minimumSize,
  }) = _AppSmallButton;

  const factory AppButton.outline({
    required VoidCallback? onPressed,
    required Widget child,
    Size? minimumSize,
    Size? maximumSize,
    Size? fixedSize,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    OutlinedBorder? shape,
  }) = _AppOutlineButton;

  const factory AppButton.icon({
    required VoidCallback? onPressed,
    required Widget icon,
    Size? minimumSize,
    Size? maximumSize,
    Size? fixedSize,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    OutlinedBorder? shape,
  }) = _AppIconButton;

  const factory AppButton.text({
    required VoidCallback? onPressed,
    required Widget child,
    Size? minimumSize,
    Size? maximumSize,
    Size? fixedSize,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    OutlinedBorder? shape,
    bool showUnderline,
    Color? underLineColor,
  }) = _AppTextButton;

  const factory AppButton.medium({
    required VoidCallback? onPressed,
    required Widget child,
    Size? maximumSize,
    Size? fixedSize,
    Color? backgroundColor,
    Color? foregroundColor,
    OutlinedBorder? shape,
  }) = _AppMediumButton;

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonType type;
  final Size? minimumSize;
  final Size? maximumSize;
  final Size? fixedSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final OutlinedBorder? shape;
  final bool showUnderline;
  final Color? underLineColor;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppButtonType.small:
      case AppButtonType.medium:
      case AppButtonType.primary:
        return FilledButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.surfaceContainerPrimaryPrimaryDisabled;
              }
              return backgroundColor ??
                  AppColors.surfaceContainerPrimaryPrimaryDefault;
            }),

            foregroundColor: WidgetStatePropertyAll(foregroundColor),
            textStyle: WidgetStatePropertyAll(textStyle),
            minimumSize: WidgetStatePropertyAll(minimumSize),
            maximumSize: WidgetStatePropertyAll(maximumSize),
            fixedSize: WidgetStatePropertyAll(fixedSize),
            shape: WidgetStatePropertyAll(
              shape ??
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
            ),
          ),
          child: child,
        );
      case AppButtonType.sub:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: minimumSize,
            maximumSize: maximumSize,
            fixedSize: fixedSize,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            textStyle: textStyle,
            shape: shape,
          ),
          child: child,
        );
      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: minimumSize,
            maximumSize: maximumSize,
            side: shape?.side,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            textStyle: textStyle,
            shape: shape,
          ),
          child: child,
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: minimumSize,
            maximumSize: maximumSize,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            textStyle: textStyle,
            shape: shape,
          ),
          child: Container(
            padding: const EdgeInsets.only(bottom: 1),
            decoration: BoxDecoration(),
            child: child,
          ),
        );
      case AppButtonType.icon:
        final constraints = BoxConstraints(
          minHeight: fixedSize?.height ?? 44,
          minWidth: fixedSize?.width ?? 44,
        );

        return IconButton(
          onPressed: onPressed,
          icon: child,
          constraints: constraints,
          padding: EdgeInsets.zero,
        );
    }
  }
}

class _AppPrimaryButton extends AppButton {
  const _AppPrimaryButton({
    required super.onPressed,
    required super.child,
    Size? minimumSize,
    super.maximumSize,
    super.fixedSize,
    super.backgroundColor,
    super.foregroundColor,
    super.textStyle,
    super.shape,
  }) : super(
         type: AppButtonType.primary,
         minimumSize: minimumSize ?? const Size(double.infinity, 48),
       );
}

class _AppSubButton extends AppButton {
  const _AppSubButton({
    required super.onPressed,
    required super.child,
    Size? minimumSize,
    super.maximumSize,
    super.fixedSize,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    super.shape,
  }) : super(
         type: AppButtonType.sub,
         minimumSize: minimumSize ?? const Size(57, 26),
       );
}

class _AppSmallButton extends AppButton {
  const _AppSmallButton({
    required super.onPressed,
    required super.child,
    super.maximumSize,
    super.fixedSize,
    super.backgroundColor,
    super.foregroundColor,
    TextStyle? textStyle,
    Size? minimumSize,
    super.shape,
  }) : super(
         type: AppButtonType.small,
         minimumSize: minimumSize ?? const Size(48, 32),
       );
}

class _AppOutlineButton extends AppButton {
  const _AppOutlineButton({
    required super.onPressed,
    required super.child,
    super.minimumSize,
    super.maximumSize,
    super.fixedSize,
    super.backgroundColor,
    super.foregroundColor,
    super.textStyle,
    super.shape,
  }) : super(type: AppButtonType.outline);
}

class _AppIconButton extends AppButton {
  const _AppIconButton({
    required super.onPressed,
    required Widget icon,
    super.minimumSize,
    super.maximumSize,
    super.fixedSize,
    super.backgroundColor,
    super.foregroundColor,
    super.textStyle,
    super.shape,
  }) : super(type: AppButtonType.icon, child: icon);
}

class _AppTextButton extends AppButton {
  const _AppTextButton({
    required super.onPressed,
    required super.child,
    Size? minimumSize,
    super.maximumSize,
    super.fixedSize,
    super.backgroundColor,
    super.foregroundColor,
    super.textStyle,
    super.shape,
    super.showUnderline,
    super.underLineColor,
  }) : super(
         type: AppButtonType.text,
         minimumSize: minimumSize ?? const Size(double.infinity, 48),
       );
}

class _AppMediumButton extends AppButton {
  const _AppMediumButton({
    required super.onPressed,
    required super.child,
    super.maximumSize,
    super.fixedSize,
    super.backgroundColor,
    super.foregroundColor,
    super.shape,
  }) : super(type: AppButtonType.medium, minimumSize: const Size(48, 36));
}
