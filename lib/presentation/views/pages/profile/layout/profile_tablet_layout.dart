import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../../routers/app_router.dart';
import '../../../modal/select_image_modal.dart';
import '../profile_bloc.dart';
import '../widgets/delete_account_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_option.dart';

class ProfileTabletLayout extends StatefulWidget {
  const ProfileTabletLayout({super.key});

  @override
  State<ProfileTabletLayout> createState() => _ProfileTabletLayoutState();
}

class _ProfileTabletLayoutState extends State<ProfileTabletLayout> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = context.read<ProfileBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isDeleteAccountSuccess) {
          context.router.replaceAll([const LoginRoute()]);
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
            'profile.my_account'.tr(),
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
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 20,
              children: [
                ProfileHeader(
                  onChangeAvatar: () async {
                    final imageSource = await SelectImageModal.show(context);
                    if (imageSource != null && context.mounted) {
                      if (imageSource == ImageSource.camera) {
                        // final path = await context.router.push(
                        //   // CameraRoute(cameraMode: MediaUseCase.updateAvatar),
                        // );
                        // if (path is String) {
                        //   // _profileBloc.add(UpdateAvatarFromAccountEvent(path));
                        // }
                      } else if (imageSource == ImageSource.gallery) {
                        // _profileBloc.add(
                        //   UpdateAvatarFromLibraryEvent(),
                        // );
                      }
                    }
                  },
                  onEditName: () {
                    final name = _profileBloc.state.user?.name ?? '';
                    context.router.push(EditNameRoute(name: name));
                  },
                ),
                ProfileOption(),
                DeleteAccountButton(
                  onDeleteAccount: () {
                    _profileBloc.add(const DeleteAccountEvent());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
