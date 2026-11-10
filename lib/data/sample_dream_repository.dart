import 'package:flutter/foundation.dart';

import 'category_ang.dart';
import 'category_b.dart';
import 'category_ch.dart';
import 'category_chc.dart';
import 'category_chg.dart';
import 'category_d.dart';
import 'category_f.dart';
import 'category_fan.dart';
import 'category_hip.dart';
import 'category_k.dart';
import 'category_kh.dart';
import 'category_khr.dart';
import 'category_khw.dart';
import 'category_l.dart';
import 'category_m.dart';
import 'category_n.dart';
import 'category_ng.dart';
import 'category_p.dart';
import 'category_phan.dart';
import 'category_phueng.dart';
import 'category_r.dart';
import 'category_s.dart';
import 'category_sala.dart';
import 'category_samphao.dart';
import 'category_suea.dart';
import 'category_t.dart';
import 'category_thahan.dart';
import 'category_thong.dart';
import 'category_thung.dart';
import 'category_w.dart';
import 'category_y.dart';
import 'category_yak.dart';
import '../state/daily_pick.dart';
import 'design_data.dart';
import 'dream_images_k.dart';
import 'dream_repository.dart';
import 'number_search.dart';

/// Categories of the bundled data, in app order. Must match `dreamCats` (minus "ทั้งหมด") and the
/// backend's content categories (backend/prisma/seed-data.ts); both are checked by tests.
const sampleCategories = [
  DreamCategory(letterKCategoryId, 'หมวด ก'),
  DreamCategory(letterKhCategoryId, 'หมวด ข'),
  DreamCategory(letterKhwCategoryId, 'หมวด ค'),
  DreamCategory(letterKhrCategoryId, 'หมวด ฆ'),
  DreamCategory(letterNgCategoryId, 'หมวด ง'),
  DreamCategory(letterChCategoryId, 'หมวด จ'),
  DreamCategory(letterChgCategoryId, 'หมวด ฉ'),
  DreamCategory(letterChcCategoryId, 'หมวด ช'),
  DreamCategory(letterSCategoryId, 'หมวด ซ'),
  DreamCategory(letterYCategoryId, 'หมวด ญ'),
  DreamCategory(letterDCategoryId, 'หมวด ด'),
  DreamCategory(letterTCategoryId, 'หมวด ต'),
  DreamCategory(letterThungCategoryId, 'หมวด ถ'),
  DreamCategory(letterThahanCategoryId, 'หมวด ท'),
  DreamCategory(letterThongCategoryId, 'หมวด ธ'),
  DreamCategory(letterNCategoryId, 'หมวด น'),
  DreamCategory(letterBCategoryId, 'หมวด บ'),
  DreamCategory(letterPCategoryId, 'หมวด ป'),
  DreamCategory(letterPhuengCategoryId, 'หมวด ผ'),
  DreamCategory(letterFCategoryId, 'หมวด ฝ'),
  DreamCategory(letterPhanCategoryId, 'หมวด พ'),
  DreamCategory(letterFanCategoryId, 'หมวด ฟ'),
  DreamCategory(letterSamphaoCategoryId, 'หมวด ภ'),
  DreamCategory(letterMCategoryId, 'หมวด ม'),
  DreamCategory(letterYakCategoryId, 'หมวด ย'),
  DreamCategory(letterRCategoryId, 'หมวด ร'),
  DreamCategory(letterLCategoryId, 'หมวด ล'),
  DreamCategory(letterWCategoryId, 'หมวด ว'),
  DreamCategory(letterSalaCategoryId, 'หมวด ศ'),
  DreamCategory(letterSueaCategoryId, 'หมวด ส'),
  DreamCategory(letterHipCategoryId, 'หมวด ห'),
  DreamCategory(letterAngCategoryId, 'หมวด อ'),
];

final _slug = RegExp(r'^[a-z0-9-]{1,64}$');

/// Serves the bundled data (the real letter-category content; tests may pass other data) with the same rules as
/// the backend API (validation, search, filtering, paging). Results complete synchronously
/// ([SynchronousFuture]) so screens using it render on the first frame. The class keeps its original
/// name; it is the offline repository, used when no API_BASE_URL is configured.
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
  Future<DreamPage> list({
    String? q,
    String? categoryId,
    int page = 1,
    int limit = DreamRepository.defaultPageSize,
    DreamSort sort = DreamSort.catalogue,
  }) => _guard(() => _list(q, categoryId, page, limit, sort));

  /// Same rule as the API: name or short contains the query, an alias equals it, or it is one of the
  /// dream's lucky numbers (people often remember the number, e.g. 46; "8" also finds 08).
  static bool _matches(Dream d, String q) =>
      d.name.contains(q) ||
      d.short.contains(q) ||
      d.aliases.contains(q) ||
      d.numbers.twoDigit.contains(padNumberQuery(q, 2)) ||
      d.numbers.threeDigit.contains(q);

  DreamPage _list(String? q, String? categoryId, int page, int limit, DreamSort sort) {
    // Dart has no Thai collation; code-point order would put เ แ โ ใ ไ words after ฮ.
    if (sort != DreamSort.catalogue) throw _invalid('sort=name is only available from the API');
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
        if ((catName == null || d.cat == catName) && (query.isEmpty || _matches(d, query)))
          DreamSummary.fromDream(d, category: byName[d.cat]!),
    ];
    final start = (page - 1) * limit;
    final items = start >= matches.length
        ? <DreamSummary>[]
        : matches.sublist(start, (start + limit).clamp(0, matches.length));
    return DreamPage(items: items, page: page, limit: limit, total: matches.length);
  }

  /// Drawn on the device from the dreams that have a picture (bundled data can tell; the API cannot,
  /// since most pictures ship with the app). A catalogue without any pictures still gets a daily list.
  @override
  Future<List<DreamSummary>> daily(DateTime now, {int limit = DreamRepository.dailyCount}) => _guard(() {
    final byName = {for (final c in categoryList) c.name: c};
    final all = [for (final d in source) DreamSummary.fromDream(d, category: byName[d.cat]!)];
    final pictured = [
      for (final d in all)
        if (dreamImageFor(d.id, d.image) != null) d,
    ];
    return dailyPick(pictured.isEmpty ? all : pictured, now, limit, (d) => d.id);
  });

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
