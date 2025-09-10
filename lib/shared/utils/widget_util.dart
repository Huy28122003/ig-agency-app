import 'package:flutter/widgets.dart';

extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(Widget t) =>
      isEmpty ? [] : (enumerate.map((e) => [e.value, t]).expand((i) => i).toList()..removeLast());

  List<Widget> around(Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(Widget t) => enumerate.map((e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(Widget t) => enumerate.map((e) => e.value).toList()..add(t);

  List<Padding> paddingTopEach(double val) => map(
    (w) => Padding(
      padding: EdgeInsets.only(top: val),
      child: w,
    ),
  ).toList();
}

GestureDetector buildDismissKeyboardGesture(
  BuildContext context, {
  required Widget child,
  HitTestBehavior? behavior,
  VoidCallback? whenNoFocus,
}) {
  return GestureDetector(
    behavior: behavior,
    onTap: () {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        whenNoFocus?.call();
      }
    },
    child: child,
  );
}
