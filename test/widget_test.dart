import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/repository.dart';
import 'package:maha_dream/main.dart';

void main() {
  testWidgets('home renders title', (tester) async {
    await tester.pumpWidget(const MahaDreamApp());
    expect(find.text('🌙 มหาทำนายฝัน'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  test('locked numbers keep leading zeros as 2-char strings', () async {
    final r = await DreamRepository.instance.lockedNumbers(DateTime(2026, 10, 23));
    expect(r!.twoDigits.every((n) => n.length == 2), isTrue);
  });

  test('search finds dream by keyword', () async {
    final r = await DreamRepository.instance.search('งู');
    expect(r, isNotEmpty);
  });

  test('next draw date is 1st or 16th', () {
    expect(nextDrawDate(DateTime(2026, 10, 23)), DateTime(2026, 11, 1));
    expect(nextDrawDate(DateTime(2026, 10, 5)), DateTime(2026, 10, 16));
  });
}
