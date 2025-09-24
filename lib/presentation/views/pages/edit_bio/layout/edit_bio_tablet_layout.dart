import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/app_text_field.dart';
import '../edit_bio_bloc.dart';

class EditBioTabletLayout extends StatefulWidget {
  const EditBioTabletLayout({super.key});

  @override
  State<EditBioTabletLayout> createState() => _EditBioTabletLayoutState();
}

class _EditBioTabletLayoutState extends State<EditBioTabletLayout> {
  late final EditBioBloc _editBioBloc;

  @override
  void initState() {
    super.initState();
    _editBioBloc = context.read<EditBioBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditBioBloc, EditBioState>(
      listenWhen: (pre, cur) => pre.isSaveSuccess != cur.isSaveSuccess,
      listener: (context, state) {
        if (state.isSaveSuccess) {
          context.router.pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle.light, // Light status bar
          backgroundColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
          elevation: 0,
          toolbarHeight: 60,
          title: Text(
            'Bio',
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
          actions: [
            BlocSelector<EditBioBloc, EditBioState, String>(
              selector: (state) => state.bio,
              builder: (context, bio) {
                final isBioChanged = bio != _editBioBloc.bio;
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (isBioChanged) {
                        _editBioBloc.add(SaveBioEvent());
                      }
                    },
                    child: Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isBioChanged
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.outlineGrayStrong200, height: 1),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 24,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: BlocSelector<EditBioBloc, EditBioState, String>(
              selector: (state) => state.bio,
              builder: (context, bio) {
                return AppTextField(
                  value: bio,
                  labelText: 'Bio',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 16,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                  onChanged: (value) {
                    _editBioBloc.add(BioChangedEvent(value));
                  },
                  suffixIcon: BlocSelector<EditBioBloc, EditBioState, bool>(
                    selector: (state) {
                      return state.bio.isNotEmpty;
                    },
                    builder: (context, isBioNotEmpty) {
                      if (isBioNotEmpty) {
                        return GestureDetector(
                          onTap: () {
                            _editBioBloc.add(BioChangedEvent(''));
                          },
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Assets.icons.icCloseSize20.svg(),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
