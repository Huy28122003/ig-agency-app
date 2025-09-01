import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../resources/colors.dart';

class AppSearchTextField extends StatefulWidget {
  const AppSearchTextField({
    super.key,
    this.controller,
    this.value = '',
    this.labelText,
    this.hintText,
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
      vertical: 16,
      horizontal: 20,
    ),
    this.style,
    this.isSearchEnable = false,
    this.enableCancel = true,
    this.onSearchEnable,
  });

  final TextEditingController? controller;
  final String value;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(bool)? onSearchEnable;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final bool isSearchEnable;
  final bool enableCancel;
  final TextStyle? style;

  @override
  State<AppSearchTextField> createState() => _AppSearchTextFieldState();
}

class _AppSearchTextFieldState extends State<AppSearchTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  final ValueNotifier<bool> _isSearchEnable = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.value;
    _focusNode = widget.focusNode ?? FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.addListener(() {
        final hasFocus = _focusNode.hasFocus;
        if (hasFocus != _hasFocus && hasFocus && !_isSearchEnable.value) {
          _isSearchEnable.value = true;
          _hasFocus = hasFocus;
          widget.onSearchEnable?.call(hasFocus);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppSearchTextField oldWidget) {
    if (_controller.text != widget.value) {
      _controller.text = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          autofocus: false,
          controller: _controller,
          focusNode: _focusNode,
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
                color: AppColors.textDefaultTextSub,
                fontSize: 14,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
              ),
          cursorColor: widget.style?.color ?? AppColors.textDefaultTextSub,
          cursorHeight: widget.style?.fontSize ?? 14,
          decoration: InputDecoration(
            filled: true,
            // Bật background
            fillColor: Colors.white,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: AppColors.textDefaultTextSub,
              fontSize: 14,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.textDefaultTextSub,
              fontSize: 14,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
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
            suffixIconConstraints: BoxConstraints(minHeight: 52, minWidth: 52),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(
                color: AppColors.outlineGrayStrong200,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(
                color: AppColors.outlineGrayStrong200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(
                color: AppColors.outlineGrayStrong200,
                width: 1,
              ),
            ),
            contentPadding: widget.contentPadding,
          ),
        ),
        Positioned(
          right: 0,
          child: AbsorbPointer(
            absorbing: false,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (_isSearchEnable.value) {
                  _hasFocus = false;
                  _isSearchEnable.value = false;
                  widget.onChanged?.call('');
                  _focusNode.unfocus();
                  return;
                }
                _focusNode.requestFocus();
              },
              child: ValueListenableBuilder(
                valueListenable: _isSearchEnable,
                builder: (context, isEnable, _) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      top: 16,
                      bottom: 16,
                      left: 12,
                    ),
                    child:
                        widget.suffixIcon ??
                        (isEnable
                            ? Assets.icons.icCloseSize20.svg(
                                height: 20,
                                width: 20,
                              )
                            : Assets.icons.icSearch.svg(height: 20, width: 20)),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
