import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../resources/colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.value = '',
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
    this.showUnderlineBorder = true,
    this.border,
  });

  final TextEditingController? controller;
  final String value;
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
  final bool showUnderlineBorder;
  final InputBorder? border;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.value;
    _obscureText = widget.obscureText;
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    if (_controller.text != widget.value) {
      _controller.text = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.errorText.isNotNullOrEmpty;

    final underlineBorder =
        widget.border ??
        UnderlineInputBorder(
          borderSide: BorderSide(
            color: isError
                ? AppColors.outlineAlertError
                : AppColors.outlineGrayStrong200,
            width: 1,
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          obscuringCharacter: '*',
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onFieldSubmitted,
          maxLines: widget.onEditingComplete != null ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          buildCounter:
              (_, {required currentLength, maxLength, required isFocused}) {
                if (maxLength == null) return null;
                return Text(
                  "$currentLength/$maxLength",
                  style: TextStyle(
                    color: AppColors.textDefaultTextSub2,
                    fontSize: 14,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                  ),
                );
              },

          style:
              widget.style ??
              TextStyle(
                color: AppColors.textDefaultTextSub2,
                fontSize: 16,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
          cursorColor: widget.style?.color ?? AppColors.textDefaultTextSub2,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: AppColors.textDefaultTextSub,
              fontSize: 14,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 1.14,
            ),
            hintText: widget.hintText,
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
              maxWidth: 20 + (widget.contentPadding?.left ?? 0),
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(
                      left: widget.contentPadding?.left ?? 0,
                    ),
                    child: widget.prefixIcon,
                  )
                : null,
            suffixIconConstraints: BoxConstraints(
              maxHeight: 20,
              maxWidth: 20 + (widget.contentPadding?.right ?? 0),
            ),
            suffixIcon: widget.obscureText
                ? _buildSuffixIcon()
                : widget.suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(
                      right: widget.contentPadding?.right ?? 0,
                    ),
                    child: widget.suffixIcon,
                  )
                : null,
            border: widget.showUnderlineBorder
                ? underlineBorder
                : InputBorder.none,
            enabledBorder: widget.showUnderlineBorder
                ? underlineBorder
                : InputBorder.none,
            focusedBorder: widget.showUnderlineBorder
                ? underlineBorder
                : InputBorder.none,
            disabledBorder: widget.showUnderlineBorder
                ? underlineBorder
                : InputBorder.none,
            contentPadding: widget.contentPadding,
          ),
        ),
        if (isError) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
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

  Widget? _buildSuffixIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      child: SizedBox(
        height: 20,
        width: 20,
        child: _obscureText
            ? Assets.icons.icEye.svg()
            : Assets.icons.icEyeOff.svg(),
      ),
    );
  }
}
