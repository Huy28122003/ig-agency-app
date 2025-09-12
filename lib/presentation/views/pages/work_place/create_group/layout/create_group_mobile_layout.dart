import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../domain/entities/user_entity.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/app_checkbox.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/app_search_text_field.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../create_group_bloc.dart';

class CreateGroupMobileLayout extends StatefulWidget {
  const CreateGroupMobileLayout({super.key});

  @override
  State<CreateGroupMobileLayout> createState() =>
      _CreateGroupMobileLayoutState();
}

class _CreateGroupMobileLayoutState extends State<CreateGroupMobileLayout> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final bloc = context.read<CreateGroupBloc>();
      if (bloc.state.pageStatus != PageStatus.loading &&
          bloc.state.pagination.hasMore) {
        bloc.add(LoadMoreDataEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateGroupBloc, CreateGroupState>(
          listenWhen: (previous, current) {
            return previous.createGroupSuccess != current.createGroupSuccess;
          },
          listener: (context, state) {
            if (state.createGroupSuccess) {
              //TODO: xử lý reload màn WorkspaceListPage khi tạo nhóm thành công
              context.router.pop();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.surfaceBackgroundBackground,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: AppColors.surfaceBackgroundBackground,
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 4),
                    _buildGroupName(),
                    const SizedBox(height: 8),
                    _buildInputSearch(),
                    const SizedBox(height: 8),
                    _buildListUserSelected(),
                    Expanded(child: _buildListUser()),
                  ],
                ),
              ),
              _buildButtonCreate(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Stack(
            children: [
              Center(
                child: Text(
                  'create_group.title'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDefaultTextDefault,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text(
                      'create_group.cancel'.tr(),
                      style: TextStyle(fontSize: 14, color: Color(0xFF6A7282)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE5E7EB)),
      ],
    );
  }

  Widget _buildGroupName() {
    return BlocSelector<CreateGroupBloc, CreateGroupState, String>(
      selector: (state) {
        return state.groupName;
      },
      builder: (context, groupName) {
        return AppTextField(
          value: groupName,
          hintText: 'create_group.hint_group_name'.tr(),
          showUnderlineBorder: false,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textDefaultTextDefault,
            fontWeight: FontWeight.w400,
          ),
          onChanged: (value) {
            context.read<CreateGroupBloc>().add(GroupNameChangedEvent(value));
          },
        );
      },
    );
  }

  Widget _buildInputSearch() {
    return BlocSelector<CreateGroupBloc, CreateGroupState, String>(
      selector: (state) {
        return state.searchKeyWord;
      },
      builder: (context, searchKeyWord) {
        return Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: AppSearchTextField(
            style: TextStyle(
              color: AppColors.textDefaultTextSub,
              fontSize: 16,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
            ),
            hintStyle: TextStyle(
              color: Color(0xFF6A7282),
              fontSize: 16,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
            ),
            fillColor: const Color(0xFFE5E7EB),
            hintText: 'create_group.search_member'.tr(),
            contentPadding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 14,
              bottom: 14,
            ),
            value: searchKeyWord,
            onChanged: (value) {
              context.read<CreateGroupBloc>().add(
                SearchKeyWordChangedEvent(value),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildListUserSelected() {
    return BlocSelector<CreateGroupBloc, CreateGroupState, List<UserEntity>>(
      selector: (state) {
        return state.listSelectedUser;
      },
      builder: (context, listSelectedUser) {
        if (listSelectedUser.isEmpty) {
          return const SizedBox(height: 0);
        }

        return Container(
          height: 84,
          padding: const EdgeInsets.only(top: 14, left: 20, right: 20),
          child: ListView.separated(
            itemCount: listSelectedUser.length,
            itemBuilder: (context, index) {
              final item = listSelectedUser[index];
              return SizedBox(
                width: 64,
                height: 70,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        CircleNetworkAvatar(imageUrl: item.avatar, size: 40),
                        const SizedBox(height: 6),
                        Center(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textDefaultTextDefault,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: -2,
                      child: GestureDetector(
                        onTap: () {
                          context.read<CreateGroupBloc>().add(
                            SelectUserEvent(item, false),
                          );
                        },
                        child: Assets.icons.icMinus.svg(),
                      ),
                    ),
                  ],
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 8);
            },
          ),
        );
      },
    );
  }

  Widget _buildListUser() {
    return BlocSelector<
      CreateGroupBloc,
      CreateGroupState,
      (List<UserEntity>, List<UserEntity>)
    >(
      selector: (state) {
        return (state.listUser, state.listSelectedUser);
      },
      builder: (context, listUser) {
        if (listUser.$1.isEmpty) {
          return Center(
            child: Text(
              'create_group.no_user_found'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textDefaultTextSub,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 60),
          itemCount: listUser.$1.length,
          itemBuilder: (context, index) {
            final item = listUser.$1[index];
            final isSelected =
                listUser.$2.firstOrNullWhere((e) => e.id == item.id) != null;
            return InkWell(
              onTap: () {
                context.read<CreateGroupBloc>().add(
                  SelectUserEvent(item, !isSelected),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        CircleNetworkAvatar(imageUrl: item.avatar, size: 48),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textDefaultTextDefault,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppCheckBox(
                          value: isSelected,
                          onChanged: (value) {
                            context.read<CreateGroupBloc>().add(
                              SelectUserEvent(item, !value),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 56),
                    child: Divider(height: 1, color: Color(0xFFE5E7EB)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtonCreate() {
    return BlocSelector<CreateGroupBloc, CreateGroupState, List<UserEntity>>(
      selector: (state) {
        return state.listSelectedUser;
      },
      builder: (context, listSelectedUser) {
        return Positioned(
          bottom: 18,
          left: 40,
          right: 40,
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (listSelectedUser.isNotEmpty) {
                  context.read<CreateGroupBloc>().add(SubmitCreateGroupEvent());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: listSelectedUser.isEmpty
                    ? const Color(0xFFFEE2AD)
                    : const Color(0xFFFCB732),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                "create_group.create_group".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      },
    );
  }
}
