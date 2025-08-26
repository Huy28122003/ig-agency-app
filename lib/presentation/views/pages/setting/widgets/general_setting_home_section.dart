import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../routers/app_router.dart';
import '../home/setting_home_bloc.dart';
import 'setting_card.dart';
import 'setting_item.dart';

class GeneralSettingHomeSection extends StatelessWidget {
  const GeneralSettingHomeSection({super.key, required this.settingHomeBloc});

  final SettingHomeBloc settingHomeBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        SettingCard(
          items: [
            SettingItem(
              icon: Assets.icons.icDarkMode.svg(width: 32, height: 32),
              title: 'Dark mode',
              trailing: BlocSelector<SettingHomeBloc, SettingHomeState, bool>(
                selector: (state) => state.isDarkMode,
                builder: (context, isDarkMode) {
                  return SizedBox(
                    width: 51,
                    height: 31,
                    child: CupertinoSwitch(
                      value: isDarkMode,
                      onChanged: (_) {
                        settingHomeBloc.add(ToggleDarkModeEvent());
                      },
                    ),
                  );
                },
              ),
              onTap: () {
                settingHomeBloc.add(ToggleDarkModeEvent());
              },
            ),
            SettingItem(
              icon: Assets.icons.icPinMessages.svg(width: 32, height: 32),
              title: 'Pin Messages',
              isShowArrow: true,
              onTap: () {
                context.router.push(const PinnedMessageRoute());
              },
            ),
          ],
        ),
        SettingCard(
          items: [
            SettingItem(
              icon: Assets.icons.icBlockUsers.svg(width: 32, height: 32),
              title: 'Blocked Users',
              isShowArrow: true,
              onTap: () {
                // TODO route
              },
            ),
            SettingItem(
              icon: Assets.icons.icInAppAlerts.svg(width: 32, height: 32),
              title: 'In App alerts',
              trailing: BlocSelector<SettingHomeBloc, SettingHomeState, bool>(
                selector: (state) => state.isInAppAlerts,
                builder: (context, isInAppAlerts) {
                  return SizedBox(
                    width: 51,
                    height: 31,
                    child: CupertinoSwitch(
                      value: isInAppAlerts,
                      onChanged: (_) {
                        settingHomeBloc.add(ToggleInAppAlertsEvent());
                      },
                    ),
                  );
                },
              ),
              onTap: () {
                settingHomeBloc.add(ToggleInAppAlertsEvent());
              },
            ),
          ],
        ),
      ],
    );
  }
}
