import 'package:flutter/widgets.dart';

import '../data/design_data.dart';
import '../data/dream_repository.dart';
import '../data/sample_dream_repository.dart';

/// The bottom tabs, in order; each one keeps its own page stack.
const appTabs = ['home', 'dream', 'lucky', 'ritual', 'book'];

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
  final Map<String, List<AppPage>> _stacks = {for (final t in appTabs) t: [_root(t)]};
  String query = '';
  String cat = 'ทั้งหมด';

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

  /// [focus]: the person tapped a search box (Home) and wants to type now, so the search screen
  /// puts the cursor in its box and opens the keyboard.
  void goSearch({bool resetCat = false, bool focus = false}) {
    if (resetCat) cat = 'ทั้งหมด';
    if (focus) _focusSearch = true;
    goTab('dream');
  }

  bool _focusSearch = false;

  /// True once after goSearch(focus: true); the search screen calls it and focuses its box.
  bool takeSearchFocus() {
    final f = _focusSearch;
    _focusSearch = false;
    return f;
  }

  /// Opens a dream on top of the page the person is on (Home, a letter list or the search), so Back
  /// returns there. Opening another dream from a dream page replaces it instead of stacking up.
  void openDream(String id) {
    final stack = _stacks[tab]!;
    if (stack.last is ResultPage) stack.removeLast();
    stack.add(ResultPage(id));
    notifyListeners();
  }

  void openFeat(String k) {
    // Menu 1 (พยากรณ์โชคชะตาชีวิต จากความฝัน + ตัวเลข + รูป) is the dream book itself: open the search.
    if (k == '1') return goSearch(resetCat: true);
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
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({super.key, required AppController controller, required super.child})
      : super(notifier: controller);

  static AppController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
