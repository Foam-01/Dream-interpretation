/// Number search: people type "5" for 05 and "10" for picture 010, so a query of digits only that is
/// shorter than a [width]-digit number is compared with zeros in front ("5" → "05").
///
/// Used only where a short number means the same thing: list numbers (animal 05, pae picture 010) and
/// two-digit lucky numbers. Three-digit lucky numbers are compared as typed, because 98 and 098 are
/// different lottery numbers.
String padNumberQuery(String query, int width) =>
    _digits.hasMatch(query) && query.length < width ? query.padLeft(width, '0') : query;

final _digits = RegExp(r'^[0-9]+$');
