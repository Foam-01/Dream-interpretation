// F03 user flows: Back from a dream returns where it was opened, Home follows the date after the app
// comes back from the background on a new day, and scrolling results puts the keyboard away.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/formulas.dart';
import 'package:maha_dream/main.dart';

void main() {
  Future<AppController> open(WidgetTester tester, {DateTime Function()? clock}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MahaDreamApp(clock: clock ?? DateTime.now));
    await tester.pumpAndSettle();
    return AppScope.of(tester.element(find.byType(Scaffold).first));
  }

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.text('กลับ').first);
    await tester.pumpAndSettle();
  }

  testWidgets('a dream opened from a letter list goes back to that list', (tester) async {
    final app = await open(tester);
    app.openFeat('13');
    await tester.pumpAndSettle();
    await tester.tap(find.text('กบ').first);
    await tester.pumpAndSettle();
    expect(find.text('เลขนำโชคจากความฝัน'), findsOneWidget);
    await back(tester);
    expect(find.text('ทำนายฝันหมวด ก'), findsWidgets, reason: 'back on the ก list, not the search');
    expect(app.tab, 'book');
  });

  testWidgets('a dream opened from Home goes back to Home', (tester) async {
    final app = await open(tester);
    app.openDream('k-frog');
    await tester.pumpAndSettle();
    await back(tester);
    expect(find.text('เมนูยอดนิยม'), findsOneWidget);
    expect(app.tab, 'home');
  });

  testWidgets('a dream opened from search goes back to the results with the same words', (tester) async {
    final app = await open(tester);
    app.goTab('dream');
    app.setQuery('งู');
    await tester.pumpAndSettle();
    await tester.tap(find.text('งู').last);
    await tester.pumpAndSettle();
    await back(tester);
    expect(find.text('ค้นหาความฝัน'), findsWidgets);
    expect(app.query, 'งู');
  });

  testWidgets('coming back from the background on a new day shows the new draw', (tester) async {
    var now = DateTime(2026, 11, 15, 10);
    await open(tester, clock: () => now);
    expect(find.text('งวด ${thaiDateShort(nextDrawDate(now))}'), findsOneWidget);
    now = DateTime(2026, 11, 17, 10); // the 16th draw has passed
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.text('งวด ${thaiDateShort(nextDrawDate(now))}'), findsOneWidget);
    expect(find.text('งวด ${thaiDateShort(DateTime(2026, 11, 16))}'), findsNothing);
  });

  testWidgets('scrolling the results puts the keyboard away', (tester) async {
    final app = await open(tester);
    app.goSearch(focus: true);
    await tester.pumpAndSettle();
    final box = find.byKey(const ValueKey('dream-search'));
    expect(tester.widget<TextField>(box).focusNode!.hasFocus, isTrue);
    await tester.drag(find.byKey(const ValueKey('search-results')), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(box).focusNode!.hasFocus, isFalse);
  });
}
