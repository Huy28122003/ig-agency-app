import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/di/di.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/shared/utils/alert.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:responsive_builder/responsive_builder.dart';
import '../../shared/commons/enums/status.dart';
import '../../shared/utils/keyboard_utils.dart';
import '../../shared/utils/logger.dart';
import 'base_state.dart';

abstract class BasePage<B extends BaseBloc<E, S>, E, S extends BaseState<S>>
    extends StatefulWidget
    implements AutoRouteWrapper {
  const BasePage({super.key, this.needRemoveSplash = false});

  final bool needRemoveSplash;

  Widget buildLoadingView(BuildContext context) {
    return Container();
  }

  Widget buildErrorView(String? errorMessage, VoidCallback onRefresh) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(errorMessage ?? 'An error occurred'),
              AppButton.primary(onPressed: onRefresh, child: Text('Refresh')),
            ],
          ),
        ),
      ),
    );
  }

  @mustCallSuper
  void onInitState(BuildContext context) {
    loggerNoStack.i('$runtimeType screen created');
  }

  @mustCallSuper
  void onDispose(BuildContext context) {
    loggerNoStack.i('$runtimeType screen disposed');
  }

  void onRefresh() {}

  Widget? desktopBuilder(BuildContext context) {
    return null;
  }

  PreferredSizeWidget? appbarMobileBuilder(BuildContext context) {
    return null;
  }

  PreferredSizeWidget? appbarTabletBuilder(BuildContext context) {
    return null;
  }

  PreferredSizeWidget? appbarDesktopBuilder(BuildContext context) {
    return null;
  }

  Widget? tabletBuilder(BuildContext context) {
    return null;
  }

  Widget mobileBuilder(BuildContext context);

  B get buildBloc => getIt<B>();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<B>(create: (_) => buildBloc, child: this);
  }

  @override
  State<BasePage> createState() => _BasePageState<B, E, S>();
}

class _BasePageState<B extends BaseBloc<E, S>, E, S extends BaseState<S>>
    extends State<BasePage>
    with WidgetsBindingObserver {
  late AppAlertDialog _appDialog;

  @override
  void initState() {
    super.initState();
    _appDialog = getIt<AppAlertDialog>();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.needRemoveSplash) {
        FlutterNativeSplash.remove();
      }
      widget.onInitState(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Todo: anh.trandang
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.onDispose(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<B, S>(
          listener: (context, state) async {
            if (state.processing) {
              _appDialog.show(context, type: AppAlertType.loading);
            } else {
              _appDialog.hide(context);
            }
          },
          listenWhen: (pre, cur) => pre.processing != cur.processing,
        ),
      ],
      child: ResponsiveBuilder(
        breakpoints: const ScreenBreakpoints(
          desktop: 1300,
          tablet: 600,
          watch: 200,
        ),
        builder: (context, sizingInfo) {
          return BlocBuilder<B, S>(
            buildWhen: (pre, cur) => cur.pageStatus != pre.pageStatus,
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: _getAppBarBuilder(context, sizingInfo),
                resizeToAvoidBottomInset: false,
                body: _buildBody(
                  context,
                  sizingInfo,
                  state.pageStatus,
                  state.pageErrorMessage,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SizingInformation sizingInfo,
    PageStatus pageStatus,
    String? messageError,
  ) {
    switch (pageStatus) {
      case PageStatus.initial:
      case PageStatus.refreshing:
      case PageStatus.loading:
        return widget.buildLoadingView(context);
      case PageStatus.loaded:
        final builder = _getBodyBuilder(context, sizingInfo);

        return builder;
      case PageStatus.failure:
        return widget.buildErrorView(messageError, () {
          widget.onRefresh();
        });
    }
  }

  PreferredSizeWidget? _getAppBarBuilder(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    PreferredSizeWidget? builder;
    switch (sizingInformation.deviceScreenType) {
      case DeviceScreenType.mobile:
        builder = widget.appbarMobileBuilder(context);
      case DeviceScreenType.tablet:
        builder = widget.appbarTabletBuilder(context);
      default:
        builder = widget.appbarDesktopBuilder(context);
    }
    return builder;
  }

  Widget _getBodyBuilder(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    Widget? builder;
    switch (sizingInformation.deviceScreenType) {
      case DeviceScreenType.mobile:
        builder = widget.mobileBuilder(context);
      case DeviceScreenType.tablet:
        builder = widget.tabletBuilder(context);
      default:
        builder = widget.desktopBuilder(context);
    }
    if (sizingInformation.isMobile || sizingInformation.isTablet) {
      return GestureDetector(
        onTap: () {
          KeyboardUtils.hideKeyboard();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: builder,
      );
    }
    return builder ?? SizedBox();
  }
}
