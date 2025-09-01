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
    this.noBorder = false,
    this.hintStyle,
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
  final bool noBorder;
  final TextStyle? hintStyle;

  final TextStyle? style;

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
    final isError = widget.errorText != null;

    final underlineBorder = UnderlineInputBorder(
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
            hintStyle:
                hintStyle ??
                TextStyle(
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
            border: noBorder ? InputBorder.none : underlineBorder,
            enabledBorder: noBorder ? InputBorder.none : underlineBorder,
            focusedBorder: noBorder ? InputBorder.none : underlineBorder,
            disabledBorder: noBorder ? InputBorder.none : underlineBorder,

            contentPadding: contentPadding,
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
