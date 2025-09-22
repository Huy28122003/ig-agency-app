import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/views/pages/fowrard/forward_bottom_sheet.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/bloc/media_detail_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/widgets/image_widget.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/widgets/video_widget.dart';
import 'package:ig_agency_app/shared/commons/enums/menu_option.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';

class MediaDetailMobileLayout extends StatefulWidget {
  const MediaDetailMobileLayout({super.key});

  @override
  State<MediaDetailMobileLayout> createState() =>
      _MediaDetailMobileLayoutState();
}

class _MediaDetailMobileLayoutState extends State<MediaDetailMobileLayout> {
  late final MediaDetailBloc _mediaDetailBloc;

  @override
  void initState() {
    super.initState();
    _mediaDetailBloc = context.read<MediaDetailBloc>();
  }

  @override
  void dispose() {
    _mediaDetailBloc.videoPlayerController?.dispose();
    _mediaDetailBloc.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MediaDetailBloc, MediaDetailState, bool>(
      selector: (state) {
        return state.isFullScreenMode;
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.surfaceBackgroundBackground,
              appBar: AppBar(
                backgroundColor: AppColors.surfaceBackgroundBackground,
                elevation: 0,
                leadingWidth: 52,
                leading: Container(
                  padding: const EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.all(8),
                    onPressed: () {
                      context.router.pop();
                    },
                    icon: Assets.icons.icCloseSize24.svg(
                      colorFilter: ColorFilter.mode(
                        AppColors.iconPrimaryDefault,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: (){
                      _mediaDetailBloc.add(DownloadMediaEvent());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Assets.icons.icDownload.svg(
                        colorFilter: ColorFilter.mode(
                          AppColors.iconPrimaryDefault,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    constraints: BoxConstraints(maxWidth: 250),
                    padding: EdgeInsets.zero,
                    onSelected: (option) {
                      if (option == MenuOption.forward) {
                        ForwardBottomSheet.show(context, messageId: "1");
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: AppColors.surfaceContainerGrayStrong0,
                    offset: const Offset(0, 40),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<MenuOption>>[
                          PopupMenuItem<MenuOption>(
                            height: 30,
                            value: MenuOption.forward,
                            child: SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Forward",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        height: 24 / 16,
                                        color: AppColors.textDefaultTextDefault,
                                        fontFamily: FontFamily.segoeUI,
                                      ),
                                    ),
                                  ),
                                  Assets.icons.icForward.svg(),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem<MenuOption>(
                            height: 30,
                            value: MenuOption.copy,
                            child: SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Copy",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        height: 24 / 16,
                                        color: AppColors.textDefaultTextDefault,
                                        fontFamily: FontFamily.segoeUI,
                                      ),
                                    ),
                                  ),
                                  Assets.icons.icCopy.svg(),
                                ],
                              ),
                            ),
                          ),
                        ],
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Assets.icons.icMore.svg(
                          colorFilter: ColorFilter.mode(
                            AppColors.iconPrimaryDefault,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              body: PageView.builder(
                controller: _mediaDetailBloc.pageController,
                onPageChanged: (index) {
                  _mediaDetailBloc.add(ChangeMediaEvent(index: index));
                  if (_mediaDetailBloc.medias[index].isVideo) {
                    _mediaDetailBloc.add(LoadVideoEvent(index: index));
                  }
                },
                itemBuilder: (context, index) {
                  return (_mediaDetailBloc.medias[index].isVideo)
                      ? VideoWidget()
                      : Center(
                          child: ImageWidget(
                            isFullScreenMode: false,
                            imageIndex: index,
                          ),
                        );
                },
                itemCount: _mediaDetailBloc.medias.length,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state
                  ? ImageWidget(
                      isFullScreenMode: true,
                      imageIndex: _mediaDetailBloc.state.imageIndex,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
