import 'package:flutter/foundation.dart';

import '../data/dream_repository.dart';

enum LoadStatus { idle, loading, success, failure }

/// State of one repository call, owned by a screen's State.
///
/// - Only the latest [run] may update the state: each call bumps a generation
///   number, so a slower, older response can never overwrite a newer one.
/// - A future that is already complete ([SynchronousFuture], used by the
///   sample repository) is applied immediately, without a loading state, so
///   sample mode renders exactly as before on the first frame.
/// - After [dispose], late responses are ignored (no setState-after-dispose).
class LoadRequest<T> extends ChangeNotifier {
  LoadStatus status = LoadStatus.idle;
  T? value;
  DreamRepositoryException? error;

  int _generation = 0;
  bool _disposed = false;
  Future<T> Function()? _last;

  bool get isLoading => status == LoadStatus.loading;

  void run(Future<T> Function() fetch) {
    _last = fetch;
    final gen = ++_generation;
    var settled = false;
    Future<T> future;
    try {
      future = fetch();
    } catch (e) {
      future = Future.error(e);
    }
    future.then(
      (v) {
        settled = true;
        if (gen != _generation || _disposed) return;
        _set(LoadStatus.success, v, null);
      },
      onError: (Object e) {
        settled = true;
        if (gen != _generation || _disposed) return;
        _set(
          LoadStatus.failure,
          null,
          e is DreamRepositoryException
              ? e
              : DreamRepositoryException(DreamRepositoryErrorKind.unexpected, e.runtimeType.toString()),
        );
      },
    );
    if (!settled) _set(LoadStatus.loading, value, null);
  }

  /// Runs the last request again (e.g. from a Retry button).
  void retry() {
    if (_last != null) run(_last!);
  }

  /// Marks a new request as pending without starting it yet (e.g. while a
  /// search is debounced); responses to earlier requests are ignored.
  void markLoading() {
    _generation++;
    _set(LoadStatus.loading, value, null);
  }

  /// Sets a result directly (no request), invalidating pending ones.
  void complete(T v) {
    _generation++;
    _set(LoadStatus.success, v, null);
  }

  void _set(LoadStatus s, T? v, DreamRepositoryException? e) {
    status = s;
    value = v;
    error = e;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}

/// Short Thai message for a failed request; never includes server details.
String loadErrorMessage(DreamRepositoryException? e) => switch (e?.kind) {
  DreamRepositoryErrorKind.network => 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้ กรุณาตรวจสอบอินเทอร์เน็ต',
  DreamRepositoryErrorKind.timeout => 'เซิร์ฟเวอร์ตอบช้าเกินไป',
  DreamRepositoryErrorKind.server => 'เซิร์ฟเวอร์ขัดข้องชั่วคราว',
  DreamRepositoryErrorKind.invalidRequest => 'คำค้นหาไม่ถูกต้อง',
  _ => 'โหลดข้อมูลไม่สำเร็จ',
};
