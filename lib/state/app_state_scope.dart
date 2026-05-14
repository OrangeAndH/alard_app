import 'package:flutter/material.dart';
import 'app_state.dart';

class AppStateScope extends InheritedWidget {
  final AppState state;

  const AppStateScope({
    super.key,
    required this.state,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();

    if (scope == null) {
      throw FlutterError('AppStateScope was not found in the widget tree.');
    }

    return scope.state;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) => true;
}
