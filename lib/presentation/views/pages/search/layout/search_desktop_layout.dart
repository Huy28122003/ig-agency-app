import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/colors.dart';
import '../search_bloc.dart';
import '../widgets/body_search_widget.dart';
import '../widgets/header_search_tablet_widget.dart';

class SearchDesktopLayout extends StatefulWidget {
  const SearchDesktopLayout({super.key});

  @override
  State<SearchDesktopLayout> createState() => _SearchDesktopLayoutState();
}

class _SearchDesktopLayoutState extends State<SearchDesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerGrayStrong0,
      body: SafeArea(
        child: Column(
          children: [
            HeaderSearchTabletWidget(borderRadius: 12),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
