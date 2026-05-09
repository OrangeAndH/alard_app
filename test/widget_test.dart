import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alard_app/state/app_setting.dart';
import 'package:alard_app/state/app_state.dart';
import 'package:alard_app/main.dart';

void main() {
  testWidgets('Alard app opens smoke test', (WidgetTester tester) async {
    final settings = AppSettings();
    final appState = AppState();

    await tester.pumpWidget(
      AlardApp(
        settings: settings,
        appState: appState,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}