import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_shell.dart';
import 'data/design_data.dart';
import 'theme.dart';

void main() {
  // Debug builds fail fast on malformed sample data (no-op in release).
  assert(debugValidateDreams());
  runApp(const MahaDreamApp());
}

class MahaDreamApp extends StatelessWidget {
  const MahaDreamApp({super.key, this.clock = DateTime.now});

  /// Source of the current time; injectable so date-dependent screens can be
  /// tested with a fixed date. Defaults to the real clock.
  final DateTime Function() clock;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ทำนายฝัน',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('th'),
      supportedLocales: const [Locale('th'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AppShell(clock: clock),
    );
  }
}
