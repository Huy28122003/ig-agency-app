import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_workspace_bio/bloc/edit_workspace_bio_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/app_text_field.dart';

class EditWorkspaceNameMobileLayout extends StatefulWidget {
  const EditWorkspaceNameMobileLayout({super.key});

  @override
  State<EditWorkspaceNameMobileLayout> createState() =>
      _EditWorkspaceNameMobileLayoutState();
}

class _EditWorkspaceNameMobileLayoutState
    extends State<EditWorkspaceNameMobileLayout> {
  late final EditWorkspaceNameBloc _editWorkspaceBioBloc;

  @override
  void initState() {
    super.initState();
    _editWorkspaceBioBloc = context.read<EditWorkspaceNameBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditWorkspaceNameBloc, EditWorkspaceNameState>(
      listener: (_, state) {
        if (state.updateStatus ?? false) {
          context.router.pop(state.bio);
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
            BlocSelector<EditWorkspaceNameBloc, EditWorkspaceNameState, String>(
              selector: (state) {
                return state.bio;
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
                  EditWorkspaceNameBloc,
                  EditWorkspaceNameState,
                  String
                >(
                  selector: (state) {
                    return state.bio;
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
