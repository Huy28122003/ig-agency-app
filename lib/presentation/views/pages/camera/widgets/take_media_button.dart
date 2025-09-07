import 'package:flutter/material.dart';

import '../../../../resources/colors.dart';

class TakeMediaButton extends StatefulWidget {
  const TakeMediaButton({
    super.key,
    required this.isInProgress,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onTap,
  });

  final bool isInProgress;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final VoidCallback onTap;

  @override
  State<TakeMediaButton> createState() => _TakeMediaButtonState();
}

class _TakeMediaButtonState extends State<TakeMediaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // max record time
    );
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.repeat();
      }
    });
  }

  void _startRecording() {
    _controller.forward(from: 0);
    setState(() {});
  }

  void _stopRecording() {
    _controller.reset();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TakeMediaButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isInProgress != widget.isInProgress) {
      inProgress = widget.isInProgress;
      if (inProgress) {
        _startRecording();
      } else {
        _stopRecording();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => widget.onLongPressStart(),
      onLongPressEnd: (_) => widget.onLongPressEnd(),
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            width: 60 + (inProgress ? 20 : 0),
            height: 60 + (inProgress ? 20 : 0),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerAlphaAlphaWhite17,
              shape: BoxShape.circle,
            ),
            duration: Duration(milliseconds: 350),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 350),
            width: 56 + (inProgress ? 20 : 0),
            height: 56 + (inProgress ? 20 : 0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => CircularProgressIndicator(
                value: _controller.value,
                strokeWidth: 4,
                color: AppColors.surfaceContainerGrayStrong0.withValues(
                  alpha: 0.7,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 350),
            width: 40 - (inProgress ? 10 : 0),
            height: 40 - (inProgress ? 10 : 0),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerGrayStrong0,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
