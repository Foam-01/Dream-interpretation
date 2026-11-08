import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/dream_repository.dart';
import 'data/sample_dream_repository.dart';
import 'screens/feature_screen.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/result_screen.dart';
import 'screens/search_screen.dart';
import 'state/app_controller.dart';
import 'state/daily_pick.dart';
import 'theme.dart';

export 'state/app_controller.dart';

const _tabLooks = {
  'home': ('หน้าแรก', Icons.home_rounded),
  'dream': ('ทำนายฝัน', Icons.nightlight_round),
  'lucky': ('เลขเด็ด', Icons.stars_rounded),
  'ritual': ('แก้ฝัน', Icons.spa_rounded),
  'book': ('ตำรา', Icons.menu_book_rounded),
};

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.clock = DateTime.now, this.repository = const SampleDreamRepository()});

  /// Called once per screen build to give date-dependent screens a single instant.
  final DateTime Function() clock;

  /// Dream data source handed to [AppController.repository].
  final DreamRepository repository;
  @override
  State<AppShell> createState() => _AppShellState();
}

/// Widest the pages grow on tablets and landscape screens (logical pixels).
const maxContentWidth = 720.0;

/// Phones (shortest side under 600) stay upright: in landscape the header, search box and tab bar
/// leave almost no room for content. Tablets and foldables keep turning freely.
bool keepsPortrait(Size screen) => screen.shortestSide < 600;

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  late final _controller = AppController(repository: widget.repository);
  bool? _portraitOnly;

  /// The day the pages were built for: the calendar date (next draw, lock numbers) and the daily-pick
  /// day that turns over at 04:00 Thai time (ฝันเด่นวันนี้).
  late String _day = _dayOf(widget.clock());
  static String _dayOf(DateTime t) => '${DateTime(t.year, t.month, t.day)}|${dailyPickDay(t)}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  /// Back from the background on a new day: rebuild every page with today's date
  /// (people rarely close the app, they switch away and come back the next day).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final today = _dayOf(widget.clock());
    if (today != _day) setState(() => _day = today);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final portrait = keepsPortrait(MediaQuery.sizeOf(context));
    if (portrait == _portraitOnly) return;
    _portraitOnly = portrait;
    SystemChrome.setPreferredOrientations(
      portrait ? const [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown] : const [],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Widget _screenFor(AppPage page) => switch (page) {
    HomePage() => HomeScreen(now: widget.clock(), clock: widget.clock),
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
                statusBarColor: C.brand,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: C.navBar,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
              child: Scaffold(
                backgroundColor: C.bg,
                body: Column(
                  children: [
                    Container(color: C.brand, height: MediaQuery.paddingOf(context).top),
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        // Tablets and landscape: keep the phone-width layout, centred, instead of
                        // stretching cards and grids across the whole screen.
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: maxContentWidth),
                            child: KeyedSubtree(
                              // New key per page so scroll position resets like the design.
                              key: ValueKey(
                                '$_day/${_controller.tab}/${_controller.depth}/${page.runtimeType}/${_pageId(page)}',
                              ),
                              child: _screenFor(page),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Hidden while the keyboard is up, so search results keep the space on small phones.
                    if (MediaQuery.viewInsetsOf(context).bottom == 0)
                      _BottomTabs(current: _controller.tab, onTap: _controller.goTab),
                  ],
                ),
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
        color: C.navBar,
        border: Border(top: BorderSide(color: C.goldBorder)),
      ),
      padding: EdgeInsets.fromLTRB(4, 6, 4, 6 + (bottom > 0 ? bottom : 8)),
      child: Row(
        children: [
          for (final (key, (label, icon)) in [for (final t in appTabs) (t, _tabLooks[t]!)])
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: key == current ? C.gold : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(icon, size: 20, color: key == current ? C.onGold : C.tabInactive),
                        ),
                        const SizedBox(height: 3),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              label,
                              maxLines: 1,
                              style: sans(
                                12,
                                weight: FontWeight.w600,
                                color: key == current ? C.goldLight : C.tabInactive,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
