import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/number_search.dart';

void main() {
  test('a short number gets zeros in front up to the width', () {
    expect(padNumberQuery('5', 2), '05');
    expect(padNumberQuery('10', 3), '010');
    expect(padNumberQuery('7', 3), '007');
  });

  test('a full-width or longer number, words and mixed text stay as typed', () {
    expect(padNumberQuery('05', 2), '05');
    expect(padNumberQuery('1000', 3), '1000');
    expect(padNumberQuery('ม้า', 2), 'ม้า');
    expect(padNumberQuery('5ก', 2), '5ก');
    expect(padNumberQuery('', 2), '');
  });
}
