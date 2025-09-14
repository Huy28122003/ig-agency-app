import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/search/search_bloc.dart';

import '../../../widgets/app_search_text_field.dart';
import '../../../widgets/header_home_view.dart';
import '../widgets/body_search_widget.dart';

class SearchMobileLayout extends StatelessWidget {
  const SearchMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackgroundBackground,
      body: Column(
        children: [
          HeaderHomeView(
            title: 'Search',
            child: BlocSelector<SearchBloc, SearchState, String>(
              selector: (SearchState state) => state.textSearch,
              builder: (context, textSearch) {
                return AppSearchTextField(
                  value: textSearch,
                  onChanged: (value) {
                    context.read<SearchBloc>().add(SearchTextChanged(value));
                  },
                  hintText: 'Search',
                  onSearchEnable: (enable) {
                    context.read<SearchBloc>().add(ShowResultChanged(enable));
                  },
                );
              },
            ),
          ),
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
                return BodySearchWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}
