// Data access boundary for the dream catalogue.
// Screens read dreams through [DreamRepository] instead of the global sample
// list, so the source (bundled sample data or the backend API) can be swapped
// without touching the UI. The contract mirrors the backend API
// (backend/docs/flutter-integration.md).
import 'design_data.dart';

/// A dream category as served by `GET /dream-categories`.
class DreamCategory {
  /// Stable slug, e.g. `animal`.
  final String id;

  /// Thai display name, e.g. `สัตว์`.
  final String name;
  const DreamCategory(this.id, this.name);

  @override
  bool operator ==(Object other) => other is DreamCategory && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'DreamCategory($id, $name)';
}

/// Whether content is demo data or verified (API field `contentStatus`).
enum ContentStatus { sample, verified }

/// List item of `GET /dreams`: what cards and search rows show. The list
/// endpoint does not return meaning, advice, digits or forecast; use
/// [DreamRepository.byId] for those.
class DreamSummary {
  final String id, name, short;

  /// Category slug and Thai display name.
  final DreamCategory category;
  final LuckyNumbers numbers;

  /// null when the source does not say whether the dream is a good omen.
  final bool? good;

  /// null when there is no image; cards then show the placeholder.
  final DreamImage? image;
  final ContentStatus contentStatus;
  const DreamSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.short,
    required this.numbers,
    required this.good,
    required this.contentStatus,
    this.image,
  });

  /// Summary of a bundled dream (the bundled หมวด ก content is owner-approved, i.e. verified).
  DreamSummary.fromDream(Dream d, {required this.category, this.contentStatus = ContentStatus.verified})
    : id = d.id,
      name = d.name,
      short = d.short,
      numbers = d.numbers,
      good = d.good,
      image = d.image;

  /// Thai category name, like [Dream.cat].
  String get cat => category.name;
  String get two => numbers.twoDisplay;
  String get firstTwo => numbers.firstTwo;
}

/// List order: the curated catalogue order (default, what every screen uses), or Thai
/// dictionary order ก–ฮ computed by the backend with ICU collation (API `sort=name`).
enum DreamSort { catalogue, name }

/// One page of `GET /dreams` results.
class DreamPage {
  final List<DreamSummary> items;
  final int page, limit, total;
  DreamPage({required List<DreamSummary> items, required this.page, required this.limit, required this.total})
    : items = List.unmodifiable(items);

  /// Same rule as the API: zero pages when there are no results.
  int get totalPages => total == 0 ? 0 : (total + limit - 1) ~/ limit;
}

enum DreamRepositoryErrorKind {
  /// The request broke the API contract (bad page/limit/query/category/id).
  invalidRequest,

  /// The server has no such resource (other than an unknown dream id, which
  /// [DreamRepository.byId] reports as null). Usually a wrong base URL.
  notFound,

  /// No connection, DNS or TLS failure.
  network,

  /// No response within the time limit.
  timeout,

  /// The server answered with a 5xx or is unavailable.
  server,

  /// The response did not match the expected format.
  badResponse,

  /// Anything else.
  unexpected,
}

class DreamRepositoryException implements Exception {
  final DreamRepositoryErrorKind kind;

  /// Developer-facing detail; never shown to users verbatim.
  final String message;

  /// HTTP status and API error code (e.g. `VALIDATION_ERROR`) when the server answered.
  final int? statusCode;
  final String? code;
  const DreamRepositoryException(this.kind, this.message, {this.statusCode, this.code});

  @override
  String toString() =>
      'DreamRepositoryException(${kind.name}${statusCode == null ? '' : ' $statusCode'}'
      '${code == null ? '' : ' $code'}): $message';
}

/// Read-only dream catalogue. Implementations must keep lucky numbers as
/// strings (leading zeros preserved), return results in the app's order and
/// report failures as [DreamRepositoryException] through the returned future.
abstract interface class DreamRepository {
  static const defaultPageSize = 20;
  static const maxPageSize = 100;
  static const maxQueryLength = 50;

  /// True when data comes over the network (screens then debounce input and
  /// show loading/error states). Local repositories answer synchronously.
  bool get isRemote;

  /// Categories in app order (without the "ทั้งหมด" filter value).
  Future<List<DreamCategory>> categories();

  /// Dreams whose name or short summary contains the trimmed [q]
  /// (case-sensitive substring), optionally limited to [categoryId].
  /// Fails with [DreamRepositoryErrorKind.invalidRequest] for an unknown
  /// category, an over-long query or out-of-range paging.
  /// [DreamSort.name] is only available from the API; local repositories fail with
  /// [DreamRepositoryErrorKind.invalidRequest] rather than approximate Thai ordering.
  Future<DreamPage> list({
    String? q,
    String? categoryId,
    int page = 1,
    int limit = defaultPageSize,
    DreamSort sort = DreamSort.catalogue,
  });

  /// The dream with this stable id, or null when none exists.
  Future<Dream?> byId(String id);

  /// Releases resources (e.g. open connections). The repository must not be
  /// used afterwards.
  void close();
}
