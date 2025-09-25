import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../domain/entities/workspace_entity.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../widgets/app_search_text_field.dart';
import '../../../../widgets/avatar_title_checkbox_row.dart';
import '../add_to_group_bloc.dart';

class AddToGroupMobileLayout extends StatefulWidget {
  const AddToGroupMobileLayout({super.key});

  @override
  State<AddToGroupMobileLayout> createState() => _AddToGroupMobileLayoutState();
}

class _AddToGroupMobileLayoutState extends State<AddToGroupMobileLayout> {
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
      final bloc = context.read<AddToGroupBloc>();
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
        BlocListener<AddToGroupBloc, AddToGroupState>(
          listenWhen: (previous, current) {
            return previous.addToGroupSuccess != current.addToGroupSuccess;
          },
          listener: (context, state) {
            if (state.addToGroupSuccess) {
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
                    const SizedBox(height: 8),
                    _buildInputSearch(),
                    const SizedBox(height: 8),
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
    return Container(
      height: 60,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Stack(
        children: [
          Center(
            child: Text(
              'add_member.add_to_group'.tr(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDefaultTextDefault,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                context.router.push(const CreateGroupRoute());
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Center(
                child: Text(
                  'add_member.create_new'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF00BBA7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -10,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {
                context.router.pop();
              },
              icon: Assets.icons.icArrowLeft.svg(
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  Color(0xFF6A7282),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSearch() {
    return BlocSelector<AddToGroupBloc, AddToGroupState, String>(
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
            hintText: 'add_member.search_group'.tr(),
            contentPadding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 14,
              bottom: 14,
            ),
            value: searchKeyWord,
            onChanged: (value) {
              context.read<AddToGroupBloc>().add(
                SearchKeyWordChangedEvent(value),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildListUser() {
    return BlocSelector<
      AddToGroupBloc,
      AddToGroupState,
      (List<GroupEntity>, List<GroupEntity>)
    >(
      selector: (state) {
        return (state.listGroup, state.listSelectedGroup);
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
            return AvatarTitleCheckboxRow(
              imageUrl: item.groupAvatar,
              title: item.groupName,
              isSelected: isSelected,
              onTap: () {
                context.read<AddToGroupBloc>().add(
                  SelectGroupEvent(item, !isSelected),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildButtonCreate() {
    return BlocSelector<AddToGroupBloc, AddToGroupState, List<GroupEntity>>(
      selector: (state) {
        return state.listSelectedGroup;
      },
      builder: (context, listSelectedGroup) {
        return Positioned(
          bottom: 18,
          left: 40,
          right: 40,
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (listSelectedGroup.isNotEmpty) {
                  context.read<AddToGroupBloc>().add(SubmitAddToGroupEvent());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: listSelectedGroup.isEmpty
                    ? AppColors.surfaceContainerPrimaryPrimaryDisabled
                    : AppColors.outlinePrimaryDefault,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                listSelectedGroup.isEmpty
                    ? "add_member.add_to_group".tr()
                    : "add_member.add_to_group_with_number".tr(
                        args: ['${listSelectedGroup.length}'],
                      ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      },
    );
  }
}
