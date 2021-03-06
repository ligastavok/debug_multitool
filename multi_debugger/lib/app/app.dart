import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multi_debugger/app/theme.dart';
import 'package:multi_debugger/app_globals.dart';
import 'package:multi_debugger/di/app_di.dart';
import 'package:multi_debugger/features/channel/widgets/channel_screen.dart';
import 'package:multi_debugger/features/not_allowed_platform/widgets/not_allowed_platform.dart';

class App extends StatefulWidget {
  const App({
    Key key,
  }) : super(key: key);

  @override
  State createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final AppGlobals _appGlobals = di.get<AppGlobals>();
  StreamSubscription _desktopStreamSub;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _appGlobals.initDesktopPlatformListener();
  }

  @override
  void dispose() {
    _desktopStreamSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print('didChangeAppLifecycleState state = $state');
    // actions.appLifecycle(convertToAppLifecycle(state));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _appGlobals.platformIsAllowed ? const ChannelScreen() : const NotAllowedPlatformScreen(),
      theme: appTheme,
      navigatorKey: _appGlobals.rootNavigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
      ],
      builder: (_, Widget child) {
        return child;
      },
    );
  }
}
