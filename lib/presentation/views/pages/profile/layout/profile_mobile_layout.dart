import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/dependencies/media/media_manager.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../di/di.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../shared/commons/enums/media_use_case.dart';
import '../../../../routers/app_router.dart';
import '../../../../resources/colors.dart';
import '../../../modal/select_image_modal.dart';
import '../profile_bloc.dart';
import '../widgets/delete_account_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_option.dart';

class ProfileMobileLayout extends StatefulWidget {
  const ProfileMobileLayout({super.key});

  @override
  State<ProfileMobileLayout> createState() => _ProfileMobileLayoutState();
}

class _ProfileMobileLayoutState extends State<ProfileMobileLayout> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = context.read<ProfileBloc>();
  }

  void _onChangeAvatar(BuildContext context) async {
    final imageSource = await SelectImageModal.show(context);
    String? path;
    if (!context.mounted) return;
    if (imageSource == ImageSource.camera) {
      path = await context.router.push(
        CameraRoute(mediaUseCase: MediaUseCase.updateAvatar),
      );
    } else if (imageSource == ImageSource.gallery) {
      final file = await getIt<MediaManager>().pickPhoto();
      if ((file?.path).isNotNullOrEmpty() && context.mounted) {
        path = await context.router.push(
          MediaPreviewRoute(
            mediaPath: file?.path ?? '',
            mediaUseCase: MediaUseCase.updateAvatar,
          ),
        );
      }
    }

    if (path.isNotNullOrEmpty() && context.mounted) {
      _profileBloc.add(UpdateAvatarEvent(path ?? ''));
    }
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
                  onChangeAvatar: () {
                    _onChangeAvatar(context);
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
