import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class SearchGroupCardLoading extends StatelessWidget {
  const SearchGroupCardLoading({super.key, this.padding = EdgeInsets.zero});

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 48,
      color: Colors.white,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CardLoading(
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            width: 48,
          ),
          SizedBox(width: 8),
          Expanded(
            child: CardLoading(
              height: 48,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
