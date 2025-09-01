import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/colors.dart';
import '../search_bloc.dart';
import '../widgets/body_search_widget.dart';
import '../widgets/header_search_tablet_widget.dart';

class SearchTabletLayout extends StatefulWidget {
  const SearchTabletLayout({super.key});

  @override
  State<SearchTabletLayout> createState() => _SearchTabletLayoutState();
}

class _SearchTabletLayoutState extends State<SearchTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          HeaderSearchTabletWidget(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                color: AppColors.surfaceContainerGrayStrong0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              child: BlocBuilder<SearchBloc, SearchState>(
                buildWhen: (pre, cur) {
                  return pre.textSearch.isEmpty && cur.textSearch.isNotEmpty ||
                      pre.textSearch.isNotEmpty && cur.textSearch.isEmpty;
                },
                builder: (context, state) {
                  if (state.textSearch.isEmpty) {
                    return SizedBox();
                  }
                  return BodySearchWidget(numCardLoading: 15);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
