import 'package:flutter/cupertino.dart';
import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// Main application widget
class CDKApp extends StatefulWidget {
  final String defaultAppearance;
  final String defaultColor;
  final Widget child;
  const CDKApp(
      {Key? key,
      this.defaultAppearance = "system",
      this.defaultColor = "systemBlue",
      required this.child})
      : super(key: key);

  @override
  CDKAppState createState() => CDKAppState();
}

// Main application state
class CDKAppState extends State<CDKApp> with WidgetsBindingObserver {
  late final CDKTheme _themeManager = CDKTheme();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    bool appHasFocus = (state == AppLifecycleState.resumed);
    _themeManager.setAppFocus(appHasFocus);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (_themeManager.appearanceConfig == "system") {
      _themeManager.setAppearanceConfig(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CDKThemeNotifier(
        changeNotifier: _themeManager,
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: _themeManager.getThemeData(
              context, widget.defaultAppearance, widget.defaultColor),
          home: widget.child,
        ));
  }
}