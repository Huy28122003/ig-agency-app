import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/search/search_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_search_text_field.dart';

import '../../../../../../gen/fonts.gen.dart';

class HeaderSearchWidget extends StatelessWidget {
  const HeaderSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFFFF7E4C),
            const Color(0xFFFFBA32),
            const Color(0xFFFFDB3F),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'search.search'.tr(),
                style: TextStyle(
                  color: AppColors.textDefaultTextInverted,
                  fontSize: 32,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 12),
              BlocSelector<SearchBloc, SearchState, String>(
                selector: (SearchState state) => state.textSearch,
                builder: (context, textSearch) {
                  return AppSearchTextField(
                    value: textSearch,
                    onChanged: (value) {
                      context.read<SearchBloc>().add(SearchTextChanged(value));
                    },
                    hintText: 'search.search'.tr(),
                    onSearchEnable: (enable) {
                      context.read<SearchBloc>().add(ShowResultChanged(enable));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
