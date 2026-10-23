import 'package:flutter/foundation.dart';

import 'design_data.dart';
import 'dream_repository.dart';

/// Category ids for the bundled sample data, in app order. Must match
/// `dreamCats` (minus "ทั้งหมด") and the backend seed
/// (backend/prisma/seed-data.ts); both are checked by tests.
const sampleCategories = [
  DreamCategory('animal', 'สัตว์'),
  DreamCategory('body', 'ร่างกาย'),
  DreamCategory('nature', 'ธรรมชาติ'),
  DreamCategory('person', 'บุคคล'),
  DreamCategory('object', 'สิ่งของ'),
];

final _slug = RegExp(r'^[a-z0-9-]{1,64}$');

/// Serves the bundled SAMPLE data with the same rules as the backend API
/// (validation, search, filtering, paging). Results complete synchronously
/// ([SynchronousFuture]) so screens using it can render on the first frame,
/// exactly as they do with the global lists today.
class SampleDreamRepository implements DreamRepository {
  const SampleDreamRepository({this.source = dreams, this.categoryList = sampleCategories});

  final List<Dream> source;
  final List<DreamCategory> categoryList;

  @override
  bool get isRemote => false;

  @override
  void close() {}

  @override
  Future<List<DreamCategory>> categories() => SynchronousFuture(List.unmodifiable(categoryList));

  @override
  Future<DreamPage> list({String? q, String? categoryId, int page = 1, int limit = DreamRepository.defaultPageSize}) =>
      _guard(() => _list(q, categoryId, page, limit));

  DreamPage _list(String? q, String? categoryId, int page, int limit) {
    if (page < 1) throw _invalid('page must not be less than 1');
    if (limit < 1 || limit > DreamRepository.maxPageSize) {
      throw _invalid('limit must be between 1 and ${DreamRepository.maxPageSize}');
    }
    final query = q?.trim() ?? '';
    if (query.length > DreamRepository.maxQueryLength) {
      throw _invalid('q must be at most ${DreamRepository.maxQueryLength} characters');
    }
    String? catName;
    if (categoryId != null) {
      if (!_slug.hasMatch(categoryId)) throw _invalid('category must be a category id (lowercase slug)');
      catName = categoryList.where((c) => c.id == categoryId).firstOrNull?.name;
      if (catName == null) throw _invalid('category "$categoryId" does not exist');
    }
    final byName = {for (final c in categoryList) c.name: c};
    final matches = [
      for (final d in source)
        if ((catName == null || d.cat == catName) &&
            (query.isEmpty || d.name.contains(query) || d.short.contains(query)))
          DreamSummary.fromDream(d, category: byName[d.cat]!),
    ];
    final start = (page - 1) * limit;
    final items = start >= matches.length
        ? <DreamSummary>[]
        : matches.sublist(start, (start + limit).clamp(0, matches.length));
    return DreamPage(items: items, page: page, limit: limit, total: matches.length);
  }

  @override
  Future<Dream?> byId(String id) => _guard(() {
    if (!_slug.hasMatch(id)) throw _invalid('id must be a lowercase slug (a-z, 0-9, -)');
    return dreamById(id, source);
  });

  /// Errors are delivered through the returned future (never thrown
  /// synchronously), the same way a network-backed repository reports them.
  static Future<T> _guard<T>(T Function() body) {
    try {
      return SynchronousFuture(body());
    } on DreamRepositoryException catch (e) {
      return Future.error(e);
    }
  }

  static DreamRepositoryException _invalid(String message) =>
      DreamRepositoryException(DreamRepositoryErrorKind.invalidRequest, message);
}
