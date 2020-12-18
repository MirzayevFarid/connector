import 'package:connector/pages/add_job/main.dart';
import 'package:connector/pages/add_profile/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';

// commons
import 'package:connector/common/utils.dart';
import 'package:connector/routes/tabs.dart';

// widgets
import 'package:connector/widgets/bottom_navigation_bar.dart';
import 'package:connector/widgets/connectivity_notifier.dart';

// routes
import 'package:connector/routes/main.dart';

// providers
import 'package:provider/provider.dart';
import 'package:connector/providers/navigator.dart';
import 'package:connector/utils/globals.dart';

import 'pages/home/main.dart';
import 'utils/globals.dart';

class MainContainer extends StatefulWidget {
  MainContainer({Key key}) : super(key: key);

  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer>
    with TickerProviderStateMixin {
  TabController _tabController;

  PageController pageController = PageController();
  NavigatorProvider navigationProvider;

  @override
  void initState() {
    super.initState();

    navigationProvider = context.read<NavigatorProvider>();

    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,
    )..addListener(handleTabChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final NavigatorProvider navigation = context.read<NavigatorProvider>();

    int indexOfTab =
        tabs.indexWhere((tab) => tab.route == navigation.currentTab);

    _tabController.animateTo(indexOfTab, duration: Duration(seconds: 0));
  }

  @override
  dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void handleTabChange() {
    pageController.jumpToPage(_tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorProvider navigation = context.watch<NavigatorProvider>();

    return WillPopScope(
      onWillPop: navigationProvider.onWillPop,
      child: ConnectivityNotifier(
        child: Scaffold(
          backgroundColor: Color(0xff1c1f26),
          extendBody: true,
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: tabs,
          ),
          bottomNavigationBar: ConnectorBottomNavigationBar(
            controller: _tabController,
            isBottomVisible: navigation.isBottomBarVisible,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: ORColorStyles.blue.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                onPressed: () {
                  globalUserInfo.isCompany
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddJob(),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProfile(),
                          ),
                        );
                },
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainTabView extends StatefulWidget {
  final String route;
  final Widget page;
  final String text;
  final Widget notifier;
  final Icon assetImage;
  final Icon activeAssetImage;
  final bool isLight;
  final double iconSize;

  final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  MainTabView({
    Key key,
    this.route,
    @required this.page,
    this.text,
    this.notifier,
    this.isLight = false,
    this.assetImage,
    this.activeAssetImage,
    this.iconSize = 24,
  }) : super(key: key);

  _MainContainerTabViewState createState() => _MainContainerTabViewState();
}

class _MainContainerTabViewState extends State<MainTabView>
    with AutomaticKeepAliveClientMixin<MainTabView> {
  @override
  bool get wantKeepAlive => true;

  Navigator _buildTabViewWithNavigator(Widget page) {
    return Navigator(
      key: widget.navigator,
      initialRoute: '/',
      onGenerateInitialRoutes: (state, routeName) => [
        MaterialPageRoute(
            builder: (context) => page, settings: RouteSettings(name: '/'))
      ],
      observers: [StatusBarTextRouteObserver(isRouteLight: widget.isLight)],
      onGenerateRoute: (RouteSettings settings) =>
          Routes.onGenerateRoute(settings, defaultScreen: page),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: _buildTabViewWithNavigator(widget.page),
    );
  }
}
