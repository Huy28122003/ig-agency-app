import 'package:flutter/material.dart';

import '../../../gen/fonts.gen.dart';
import '../../resources/colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 20,
    ),
    this.style,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          initialValue: initialValue,
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          obscuringCharacter: '*',
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          maxLines: onEditingComplete != null ? 1 : maxLines,
          maxLength: maxLength,
          style:
              style ??
              TextStyle(
                color: AppColors.textDefaultTextSub2,
                fontSize: 16,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
          cursorColor: style?.color ?? AppColors.textDefaultTextSub2,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: AppColors.textDefaultTextSub,
              fontSize: 14,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 1.14,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textDefaultTextSub,
              fontSize: 16,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
            isDense: true,
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              maxWidth: 20 + (contentPadding?.left ?? 0),
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: contentPadding?.left ?? 0),
                    child: prefixIcon,
                  )
                : null,
            suffixIconConstraints: BoxConstraints(
              maxHeight: 20,
              maxWidth: 20 + (contentPadding?.right ?? 0),
            ),
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: contentPadding?.right ?? 0),
                    child: suffixIcon,
                  )
                : null,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isError
                    ? AppColors.outlineAlertError
                    : AppColors.outlineGrayStrong200,
                width: 1,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isError
                    ? AppColors.outlineAlertError
                    : AppColors.outlineGrayStrong200,
                width: 1,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isError
                    ? AppColors.outlineAlertError
                    : AppColors.outlineGrayStrong200,
                width: 1,
              ),
            ),
            contentPadding: contentPadding,
          ),
        ),
        if (isError) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: TextStyle(
              color: AppColors.textAlertTextError,
              fontSize: 14,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ],
    );
  }
}
