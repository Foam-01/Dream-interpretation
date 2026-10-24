import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/design_data.dart';
import 'data/dream_repository.dart';
import 'data/sample_dream_repository.dart';
import 'screens/feature_screen.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/result_screen.dart';
import 'screens/search_screen.dart';
import 'theme.dart';

sealed class AppPage {
  const AppPage();
}

class HomePage extends AppPage {
  const HomePage();
}

class SearchPage extends AppPage {
  const SearchPage();
}

class ResultPage extends AppPage {
  final String dreamId;
  const ResultPage(this.dreamId);
}

class MenuPage extends AppPage {
  final String tab;
  const MenuPage(this.tab);
}

class FeaturePage extends AppPage {
  final String key;
  const FeaturePage(this.key);
}

/// Navigation + shared UI state, exposed to screens via [AppScope].
class AppController extends ChangeNotifier {
  AppController({this.repository = const SampleDreamRepository()});

  /// Source of dream data for Home, Search and Result (sample data or the API).
  final DreamRepository repository;

  String tab = 'home';
  final Map<String, List<AppPage>> _stacks = {for (final t in _tabs) t.$1: [_root(t.$1)]};
  String query = '';
  String cat = 'ทั้งหมด';
  final Set<String> saved = {};

  AppPage get page => _stacks[tab]!.last;
  int get depth => _stacks[tab]!.length;

  static AppPage _root(String t) => switch (t) {
        'home' => const HomePage(),
        'dream' => const SearchPage(),
        _ => MenuPage(t),
      };

  void goTab(String t) {
    tab = t;
    _stacks[t] = [_root(t)];
    notifyListeners();
  }

  void goSearch({bool resetCat = false}) {
    if (resetCat) cat = 'ทั้งหมด';
    goTab('dream');
  }

  void openDream(String id) {
    tab = 'dream';
    _stacks['dream'] = [const SearchPage(), ResultPage(id)];
    notifyListeners();
  }

  void openFeat(String k) {
    tab = tabOf(k);
    _stacks[tab] = [MenuPage(tab), FeaturePage(k)];
    notifyListeners();
  }

  /// Returns false when nothing left to pop (let the system exit).
  bool back() {
    if (depth > 1) {
      _stacks[tab]!.removeLast();
    } else if (tab != 'home') {
      tab = 'home';
    } else {
      return false;
    }
    notifyListeners();
    return true;
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  void setCat(String c) {
    cat = c;
    notifyListeners();
  }

  void toggleSave(String id) {
    saved.contains(id) ? saved.remove(id) : saved.add(id);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({super.key, required AppController controller, required super.child})
      : super(notifier: controller);

  static AppController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

const _tabs = [
  ('home', 'หน้าแรก', Icons.home_rounded),
  ('dream', 'ทำนายฝัน', Icons.nightlight_round),
  ('lucky', 'เลขเด็ด', Icons.stars_rounded),
  ('ritual', 'แก้ฝัน', Icons.spa_rounded),
  ('book', 'ตำรา', Icons.menu_book_rounded),
];

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.clock = DateTime.now, this.repository = const SampleDreamRepository()});

  /// Called once per screen build to give date-dependent screens a single instant.
  final DateTime Function() clock;

  /// Dream data source handed to [AppController.repository].
  final DreamRepository repository;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final _controller = AppController(repository: widget.repository);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _screenFor(AppPage page) => switch (page) {
        HomePage() => HomeScreen(now: widget.clock()),
        SearchPage() => const SearchScreen(),
        ResultPage(:final dreamId) => ResultScreen(dreamId: dreamId),
        MenuPage(:final tab) => MenuScreen(tab: tab),
        FeaturePage(:final key) => FeatureScreen(featKey: key, now: widget.clock()),
      };

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final page = _controller.page;
          return PopScope(
            canPop: _controller.depth == 1 && _controller.tab == 'home',
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _controller.back();
            },
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: C.red,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: C.redDeep,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
              child: Scaffold(
                backgroundColor: C.cream,
                body: Column(children: [
                  Container(color: C.red, height: MediaQuery.paddingOf(context).top),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: KeyedSubtree(
                        // New key per page so scroll position resets like the design.
                        key: ValueKey('${_controller.tab}/${_controller.depth}/${page.runtimeType}/${_pageId(page)}'),
                        child: _screenFor(page),
                      ),
                    ),
                  ),
                  _BottomTabs(current: _controller.tab, onTap: _controller.goTab),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  String _pageId(AppPage p) => switch (p) {
        ResultPage(:final dreamId) => dreamId,
        FeaturePage(:final key) => key,
        MenuPage(:final tab) => tab,
        _ => '',
      };
}

class _BottomTabs extends StatelessWidget {
  final String current;
  final ValueChanged<String> onTap;
  const _BottomTabs({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: C.redDeep,
        border: Border(top: BorderSide(color: C.goldDeep, width: 2)),
      ),
      padding: EdgeInsets.fromLTRB(4, 6, 4, 6 + (bottom > 0 ? bottom : 8)),
      child: Row(children: [
        for (final (key, label, icon) in _tabs)
          Expanded(
            child: Semantics(
              button: true,
              selected: key == current,
              label: label,
              excludeSemantics: true,
              child: InkResponse(
                onTap: () => onTap(key),
                child: SizedBox(
                  height: 48,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 34,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: key == current ? C.gold : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, size: 20, color: key == current ? C.redDeep : C.tabInactive),
                    ),
                    const SizedBox(height: 3),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(label,
                            maxLines: 1,
                            style: sans(11, color: key == current ? C.goldLight : C.tabInactive, height: 1.1)),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
