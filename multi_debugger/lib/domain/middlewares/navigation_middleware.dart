import 'package:built_redux/built_redux.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:multi_debugger/app/colors.dart';
import 'package:multi_debugger/domain/actions/actions.dart';
import 'package:multi_debugger/app_routes.dart';
import 'package:multi_debugger/domain/enums/filter_list_type.dart';
import 'package:multi_debugger/domain/models/models.dart';
import 'package:multi_debugger/domain/states/states.dart';
import 'package:multi_debugger/features/channel/components/channel_dialog/channel_dialog.dart';
import 'package:multi_debugger/features/channel/components/edit_tab_bar/edit_tab_bar.dart';
import 'package:multi_debugger/features/filter_list/widgets/filter_list_screen.dart';
import 'package:multi_debugger/features/select_url/widgets/select_url_screen.dart';

MiddlewareBuilder<AppState, AppStateBuilder, AppActions> createNavigationMiddleware() {
  return MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()..add(AppActionsNames.routeTo, _routeTo);
}

BuildContext _activeRouteContext;
// String _activeRoute;

// NavigatorState get rootNavigator => di.get<AppGlobals>().rootNavigatorKey.currentState;

void _routeTo(
  MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
  ActionHandler next,
  Action<AppRoute> action,
) async {
  next(action);

  final AppRoute payload = action.payload;

  _activeRouteContext = payload.context as BuildContext;
  // _activeRoute = payload.route;

  switch (payload.route) {
    // pop any screen
    case AppRoutes.pop:
      Navigator.of(_activeRouteContext).pop(payload.bundle);
      break;

    // edit or add channel
    case AppRoutes.editChannel:
      final ChannelModel channelModel = payload.bundle as ChannelModel;

      await showGeneralDialog<void>(
        context: _activeRouteContext,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(_activeRouteContext).modalBarrierDismissLabel,
        barrierColor: AppColors.dialogBarrierColor,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return EditTabBarScreen(
            channelModel: channelModel,
          );
        },
      );

      break;

    // select url
    case AppRoutes.selectUrl:
      await showGeneralDialog<void>(
        context: _activeRouteContext,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(_activeRouteContext).modalBarrierDismissLabel,
        barrierColor: AppColors.dialogBarrierColor,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return const SelectUrlScreen();
        },
      );

      break;

    // filter list
    case AppRoutes.filterList:
      final FilterListType filterListType = payload.bundle as FilterListType;

      await showGeneralDialog<void>(
        context: _activeRouteContext,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(_activeRouteContext).modalBarrierDismissLabel,
        barrierColor: AppColors.dialogBarrierColor,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return FilterListScreen(
            filterListType: filterListType,
          );
        },
      );

      break;

    // channel actions dialog
    case AppRoutes.showChannelActions:
      final ChannelModel currentChannelModel = payload.bundle as ChannelModel;

      await showGeneralDialog<void>(
        context: _activeRouteContext,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(_activeRouteContext).modalBarrierDismissLabel,
        barrierColor: AppColors.dialogBarrierColor,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return ChannelDialog(
            currentChannelModel: currentChannelModel,
          );
        },
      );

      break;
  }
}
