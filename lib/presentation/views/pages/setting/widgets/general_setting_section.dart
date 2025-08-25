import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../setting_bloc.dart';
import 'setting_card.dart';
import 'setting_item.dart';

class GeneralSettingSection extends StatelessWidget {
  const GeneralSettingSection({super.key, required this.settingBloc});

  final SettingBloc settingBloc;

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
              trailing: BlocSelector<SettingBloc, SettingState, bool>(
                selector: (state) => state.isDarkMode,
                builder: (context, isDarkMode) {
                  return SizedBox(
                    width: 51,
                    height: 31,
                    child: CupertinoSwitch(
                      value: isDarkMode,
                      onChanged: (_) {
                        settingBloc.add(ToggleDarkModeEvent());
                      },
                    ),
                  );
                },
              ),
              onTap: () {
                settingBloc.add(ToggleDarkModeEvent());
              },
            ),
            SettingItem(
              icon: Assets.icons.icPinMessages.svg(width: 32, height: 32),
              title: 'Pin Messages',
              isShowArrow: true,
              onTap: () {
                // TODO route
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
              trailing: BlocSelector<SettingBloc, SettingState, bool>(
                selector: (state) => state.isInAppAlerts,
                builder: (context, isInAppAlerts) {
                  return SizedBox(
                    width: 51,
                    height: 31,
                    child: CupertinoSwitch(
                      value: isInAppAlerts,
                      onChanged: (_) {
                        settingBloc.add(ToggleInAppAlertsEvent());
                      },
                    ),
                  );
                },
              ),
              onTap: () {
                settingBloc.add(ToggleInAppAlertsEvent());
              },
            ),
          ],
        ),
      ],
    );
  }
}
