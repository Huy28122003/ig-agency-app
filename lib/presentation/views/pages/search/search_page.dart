import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/search_desktop_layout.dart';
import 'layout/search_tablet_layout.dart';
import 'layout/search_mobile_layout.dart';
import 'search_bloc.dart';

@RoutePage()
class SearchPage extends BasePage<SearchBloc, SearchEvent, SearchState> {
  const SearchPage({super.key});

  @override
  void onInitState(BuildContext context) {
    context.read<SearchBloc>().add(LoadData());
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return SearchMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return SearchTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return SearchDesktopLayout();
  }
}
