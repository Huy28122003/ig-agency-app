import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class PinnedMessageLoadingItem extends StatelessWidget {
  const PinnedMessageLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CardLoading(
          height: 24,
          width: 24,
          borderRadius: BorderRadius.all(Radius.circular(48)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CardLoading(
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
