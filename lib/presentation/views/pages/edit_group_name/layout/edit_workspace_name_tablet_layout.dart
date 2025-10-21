import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/app_text_field.dart';
import '../bloc/edit_group_name_bloc.dart';

class EditWorkspaceBioTabletLayout extends StatefulWidget {
  const EditWorkspaceBioTabletLayout({super.key});

  @override
  State<EditWorkspaceBioTabletLayout> createState() =>
      _EditWorkspaceBioTabletLayoutState();
}

class _EditWorkspaceBioTabletLayoutState
    extends State<EditWorkspaceBioTabletLayout> {
  late final EditGroupNameBloc _editWorkspaceBioBloc;

  @override
  void initState() {
    super.initState();
    _editWorkspaceBioBloc = context.read<EditGroupNameBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditGroupNameBloc, EditGroupNameState>(
      listener: (_, state) {
        if (state.updateStatus ?? false) {
          context.router.pop(state.name);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
          elevation: 0,
          toolbarHeight: 60,
          title: Text(
            'workspace_bio.title'.tr(),
            style: TextStyle(
              color: AppColors.textDefaultTextInverted,
              fontSize: 22,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w700,
              height: 1.27,
            ),
          ),
          centerTitle: true,
          leadingWidth: 52,
          leading: Container(
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: IconButton(
              padding: EdgeInsets.all(8),
              onPressed: () {
                context.router.pop();
              },
              icon: Assets.icons.icArrowLeft.svg(
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.iconDefaultDefaultInverted,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.outlineGrayStrong200, height: 1),
          ),
          actions: [
            BlocSelector<EditGroupNameBloc, EditGroupNameState, String>(
              selector: (state) {
                return state.name;
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (!_editWorkspaceBioBloc.isBioChanged) return;
                      _editWorkspaceBioBloc.add(SubmitBioEvent());
                    },
                    child: Text(
                      'workspace_bio.done'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _editWorkspaceBioBloc.isBioChanged
                            ? AppColors.textDefaultTextDefault
                            : AppColors.textDefaultTextDefaultDisabled,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child:
                BlocSelector<
                  EditGroupNameBloc,
                  EditGroupNameState,
                  String
                >(
                  selector: (state) {
                    return state.name;
                  },
                  builder: (context, state) {
                    return AppTextField(
                      value: state,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 150,
                      showUnderlineBorder: false,
                      style: TextStyle(
                        color: AppColors.textDefaultTextDefault,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                      ),
                      onChanged: (value) {
                        _editWorkspaceBioBloc.add(BioChangeEvent(value: value));
                      },
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
