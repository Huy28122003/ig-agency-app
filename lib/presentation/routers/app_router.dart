import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../di/di.dart';
import '../../domain/entities/linked_device/linked_device_entity.dart';
import '../../domain/entities/media_entity.dart';
import '../views/pages/authentication/forgot_password/forgot_password_page.dart';
import '../views/pages/authentication/login/login_page.dart';
import '../views/pages/authentication/otp/otp_page.dart';
import '../views/pages/camera/camera_page.dart';
import '../views/pages/chat_info/chat_info_page.dart';
import '../views/pages/edit_workspace_bio/edit_workspace_bio_page.dart';
import '../views/pages/empty_page.dart';
import '../views/pages/authentication/registration/registration_page.dart';
import '../views/pages/authentication/reset_password/reset_password_page.dart';
import '../views/pages/media_detail/media_detail_page.dart';
import '../views/pages/media_preview/media_preview_page.dart';
import '../views/pages/group_info/group_info_page.dart';
import '../views/pages/members/members_page.dart';
import '../views/pages/nav/nav_page.dart';
import '../views/pages/pinned_message/pinned_message_page.dart';
import '../views/pages/profile/profile_page.dart';
import '../views/pages/edit_name/edit_name_page.dart';
import '../views/pages/edit_bio/edit_bio_page.dart';
import '../views/pages/change_password/change_password_page.dart';
import '../views/pages/search/search_page.dart';
import '../views/pages/setting/device_detail/device_detail_page.dart';
import '../views/pages/setting/home/setting_home_page.dart';
import '../views/pages/setting/linked_device/linked_device_page.dart';
import '../views/pages/setting/login_history/login_history_page.dart';
import '../views/pages/setting/shell/setting_page.dart';
import '../views/pages/shared_content/shared_content_page.dart';
import '../views/pages/work_place/add_to_group/add_to_group_page.dart';
import '../views/pages/work_place/detail/workspace_detail_page.dart';
import '../views/pages/work_place/list/workspace_list_page.dart';
import '../views/pages/dashboard/home/dashboard_home_page.dart';
import '../views/pages/work_place/create_group/create_group_page.dart';
import '../views/pages/work_place/user_profile/user_profile_page.dart';
import '../views/pages/workspace_attachment/workspace_attachment_page.dart';
import 'auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Dialog|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegistrationRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: OtpRoute.page),
    AutoRoute(page: ResetPasswordRoute.page),
    AutoRoute(
      guards: [getIt<AuthGuard>()],
      page: NavRoute.page,
      initial: true,
      children: [
        CustomRoute(
          page: WorkspaceListRoute.page,
          // transitionsBuilder: TransitionsBuilders.noTransition,
          children: [AutoRoute(page: CreateGroupRoute.page)],
        ),
        CustomRoute(
          page: SearchRoute.page,
          // transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: DashboardHomeRoute.page,
          // transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: SettingRoute.page,
          // transitionsBuilder: TransitionsBuilders.noTransition,
          children: [
            CustomRoute(
              page: SettingHomeRoute.page,
              transitionsBuilder: TransitionsBuilders.noTransition,
              initial: true,
            ),
            AutoRoute(page: PinnedMessageRoute.page),
            AutoRoute(page: ProfileRoute.page),
            AutoRoute(page: EditNameRoute.page),
            AutoRoute(page: EditBioRoute.page),
            AutoRoute(page: ChangePasswordRoute.page),
            AutoRoute(page: LinkedDeviceRoute.page),
          ],
        ),
        AutoRoute(page: WSDetailRoute.page),
        AutoRoute(page: ChatInfoRoute.page),
        AutoRoute(page: SharedContentRoute.page),
        AutoRoute(page: EmptyRoute.page),

        /// Mobile
        CustomRoute(
          page: SettingHomeRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
      ],
    ),

    /// Mobile
    AutoRoute(page: WSDetailRoute.page),
    AutoRoute(page: PinnedMessageRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: EditNameRoute.page),
    AutoRoute(page: EditBioRoute.page),
    AutoRoute(page: ChangePasswordRoute.page),
    AutoRoute(page: ChatInfoRoute.page),
    AutoRoute(page: SharedContentRoute.page),
    AutoRoute(page: CameraRoute.page),
    AutoRoute(page: MediaPreviewRoute.page),
    AutoRoute(page: CreateGroupRoute.page),
    AutoRoute(page: UserProfileRoute.page),
    AutoRoute(page: AddToGroupRoute.page),
    AutoRoute(page: GroupInfoRoute.page),
    AutoRoute(page: EditWorkspaceBioRoute.page),
    AutoRoute(page: MembersRoute.page),
    AutoRoute(page: WorkspaceAttachmentRoute.page),
    AutoRoute(page: MediaDetailRoute.page),
    AutoRoute(page: LinkedDeviceRoute.page),
    AutoRoute(page: DeviceDetailRoute.page),
    AutoRoute(page: LoginHistoryRoute.page),
  ];
}
