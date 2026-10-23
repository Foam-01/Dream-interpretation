import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_shell.dart';
import 'data/api_dream_repository.dart';
import 'data/design_data.dart';
import 'data/dream_repository.dart';
import 'data/sample_dream_repository.dart';
import 'theme.dart';

void main() {
  // Debug builds fail fast on malformed sample data (no-op in release).
  assert(debugValidateDreams());
  runApp(MahaDreamApp(repository: repositoryFromEnvironment(const String.fromEnvironment('API_BASE_URL'))));
}

/// `--dart-define=API_BASE_URL=<versioned API root>` (e.g. `http://10.0.2.2:3000/api/v1`)
/// selects the API; absent or empty selects the bundled sample data. An invalid
/// URL throws [FormatException] at startup instead of silently using sample data.
///
/// Release builds require `https://`: dart:io does not apply Android's
/// cleartext policy, so this check is what keeps production traffic encrypted.
DreamRepository repositoryFromEnvironment(String apiBaseUrl, {bool requireHttps = kReleaseMode}) {
  final raw = apiBaseUrl.trim();
  if (raw.isEmpty) return const SampleDreamRepository();
  final url = Uri.parse(raw);
  if (requireHttps && !url.isScheme('https')) {
    throw const FormatException('API_BASE_URL must use https:// in release builds');
  }
  return ApiDreamRepository(url);
}

class MahaDreamApp extends StatelessWidget {
  const MahaDreamApp({super.key, this.clock = DateTime.now, this.repository = const SampleDreamRepository()});

  /// Source of the current time; injectable so date-dependent screens can be
  /// tested with a fixed date. Defaults to the real clock.
  final DateTime Function() clock;

  /// Source of dream data; defaults to the bundled SAMPLE data.
  final DreamRepository repository;

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
      home: AppShell(clock: clock, repository: repository),
    );
  }
}
