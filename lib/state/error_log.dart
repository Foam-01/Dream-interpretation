import 'dart:collection';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// One recorded error: what failed, where, and when. No user input is stored here.
class ErrorRecord {
  final DateTime time;
  final String context;
  final String error;
  final StackTrace? stack;
  const ErrorRecord(this.time, this.context, this.error, this.stack);

  @override
  String toString() => '${time.toIso8601String()} [$context] $error';
}

/// The most recent errors, newest last, kept in memory so they can be read on a release build
/// (where `developer.log` records nothing): see [ErrorLogSheet]. Lost when the app closes.
class ErrorLog {
  ErrorLog._();

  static const capacity = 50;
  static final _records = ListQueue<ErrorRecord>();

  static List<ErrorRecord> get records => List.unmodifiable(_records);

  static void add(ErrorRecord r) {
    _records.addLast(r);
    while (_records.length > capacity) {
      _records.removeFirst();
    }
  }

  static void clear() => _records.clear();

  /// Plain text of every record, for copying into a bug report.
  static String report() => _records.map((r) => '$r${r.stack == null ? '' : '\n${r.stack}'}').join('\n\n');
}

/// The one place errors are recorded, so a crash reporter can be plugged in here later
/// without touching the call sites. Logs only: it never rethrows or changes what the user sees.
void logError(Object error, StackTrace? stack, {required String context, DateTime Function() now = DateTime.now}) {
  ErrorLog.add(ErrorRecord(now(), context, '$error', stack));
  developer.log('$context: $error', name: 'maha_dream', error: error, stackTrace: stack, level: 1000);
  if (kDebugMode) debugPrint('[$context] $error');
}
