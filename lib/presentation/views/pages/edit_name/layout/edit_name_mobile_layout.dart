import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/app_text_field.dart';
import '../edit_name_bloc.dart';

class EditNameMobileLayout extends StatefulWidget {
  const EditNameMobileLayout({super.key});

  @override
  State<EditNameMobileLayout> createState() => _EditNameMobileLayoutState();
}

class _EditNameMobileLayoutState extends State<EditNameMobileLayout> {
  late final EditNameBloc _editNameBloc;

  @override
  void initState() {
    super.initState();
    _editNameBloc = context.read<EditNameBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNameBloc, EditNameState>(
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
            'Name',
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
            BlocSelector<EditNameBloc, EditNameState, String>(
              selector: (state) => state.name,
              builder: (context, name) {
                final isNameChanged = name != _editNameBloc.name;
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (isNameChanged) {
                        _editNameBloc.add(SaveNameEvent());
                      }
                    },
                    child: Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isNameChanged
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
          child: Padding(
            padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
            child: BlocSelector<EditNameBloc, EditNameState, String>(
              selector: (state) => state.name,
              builder: (context, name) {
                return AppTextField(
                  labelText: 'Name',
                  value: name,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 16,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                  onChanged: (value) {
                    _editNameBloc.add(NameChangedEvent(value));
                  },
                  suffixIcon: BlocSelector<EditNameBloc, EditNameState, bool>(
                    selector: (state) {
                      return state.name.isNotEmpty;
                    },
                    builder: (context, isNameNotEmpty) {
                      if (isNameNotEmpty) {
                        return GestureDetector(
                          onTap: () {
                            _editNameBloc.add(NameChangedEvent(''));
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
