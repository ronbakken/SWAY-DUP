import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/map_view.dart';
import 'package:inf/ui/main/offer_carousel_view.dart';
import 'package:inf/ui/widgets/auth_state_listener_mixin.dart';
import 'package:inf/ui/widgets/connection_builder.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_toggle.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';

enum MainPageMode { browse, activities }
enum BrowseMode { map, list }

class MainPage extends PageWidget {
  static Route<dynamic> route(UserType userType) {
    return FadePageRoute(
      builder: (BuildContext context) => MainPage(userType: userType),
    );
  }

  const MainPage({
    Key key,
    @required this.userType,
  }) : super(key: key);

  final UserType userType;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends PageState<MainPage> with AuthStateMixin<MainPage>, SingleTickerProviderStateMixin {
  MediaQueryData mediaQuery;

  MainPageMode mainPageMode = MainPageMode.browse;
  BrowseMode browseMode = BrowseMode.map;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    return ConnectionBuilder(builder: (BuildContext context, NetworkConnectionState connectionState, Widget child) {
      return Scaffold(
        body: buildBody(),
        drawer: buildMenu(),
      );
    });
  }

  BottomNavigationBar buildNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Offers'),
          ),
          icon: InfAssetImage(
            AppIcons.offers,
            height: 30.0,
          ),
        ),
        BottomNavigationBarItem(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Proposals'),
          ),
          icon: InfAssetImage(
            AppIcons.proposal,
            height: 30.0,
          ),
        ),
        BottomNavigationBarItem(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Agreements'),
          ),
          icon: InfAssetImage(
            AppIcons.agreements,
            height: 30.0,
          ),
        ),
      ],
    );
  }

  Widget buildMenu() {
    final userManager = backend.get<UserManager>();
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 300.0,
      color: Colors.grey,
      child: Column(
        children: <Widget>[
          Text(userManager.isLoggedIn ? userManager.currentUser.name : ''),
          SizedBox(height: 10),
          buildMenuRow(AppIcons.browse, 'Browse', () {}),
          SizedBox(height: 10),
          buildMenuRow(AppIcons.history, 'History', () {}),
          SizedBox(height: 10),
          buildMenuRow(AppIcons.offers, 'Offers', () {}, CircleAvatar(radius: 8.0)),
          SizedBox(height: 10),
          buildMenuRow(AppIcons.directOffers, 'Direct', () {}),
          SizedBox(height: 10),
          buildMenuRow(AppIcons.deals, 'Deal', () {}),
        ],
      ),
    );
  }

  Widget buildMenuRow(AppAsset icon, String text, GestureTapCallback onTap, [Widget trailing]) {
    return InkWell(
      child: Row(
        children: <Widget>[
          InfAssetImage(
            icon,
            color: Colors.white,
            width: 30.0,
            height: 30.0,
          ),
          SizedBox(width: 10.0),
          Text(text),
          SizedBox(width: 10.0),
          trailing != null ? trailing : SizedBox()
        ],
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
      child: Stack(
        children: [
          Container(
            color: AppTheme.darkGrey,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomBarButtons(),
            ),
          ),

          /// The MapView
          Padding(
            padding: const EdgeInsets.only(bottom: 64),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40.0), border: Border.all(), color: AppTheme.grey),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: MapView(),
              ),
            ),
          ),

          /// Menu button
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0 + mediaQuery.padding.top),
            child: Builder(
              builder: (BuildContext context) {
                return Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkResponse(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: InfAssetImage(
                        AppIcons.menu,
                        width: 24.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Offer carousel
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              assert(constraints.hasBoundedHeight);
              return Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 96.0),
                      height: constraints.maxHeight / 4.5,
                      child: OfferCarouselView(),
                    )
                  ],
                ),
              );
            },
          ),

          // TODO Temporary only here to develop the InfToggle
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: InfToggle<BrowseMode>(
                  leftState: BrowseMode.map,
                  rightState: BrowseMode.list,
                  currentState: browseMode,
                  left: AppIcons.location,
                  right: AppIcons.browse,
                  onChanged: (mode) => setState(() => browseMode = mode),
                ),
              )),

          // The Middle INF button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                foregroundDecoration: BoxDecoration(
                  border: Border.all(color: AppTheme.buttonHalo, width: 2.0),
                  shape: BoxShape.circle,
                ),
                child: FloatingActionButton(
                  elevation: 0.0,
                  onPressed: () {},
                  backgroundColor: AppTheme.lightBlue,
                  child: InfAssetImage(
                    AppLogo.infLogo,
                    width: 24.0,
                    height: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Row _buildBottomBarButtons() {
    return Row(
      children: [
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Material(
            type: mainPageMode == MainPageMode.browse ? MaterialType.circle : MaterialType.transparency,
            color: AppTheme.darkdarkGrey,
            child: InkResponse(
              onTap: mainPageMode != MainPageMode.browse
                  ? () => setState(() {
                        mainPageMode = MainPageMode.browse;
                      })
                  : null,
              child: SizedBox(
                height: 96.0,
                width: 96.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 5.0),
                        child: InfAssetImage(
                          AppIcons.browse,
                          width: 20.0,
                        ),
                      ),
                      Text(
                        'BROWSE',
                        style: TextStyle(
                          fontSize: 10.0,
                          decoration:
                              mainPageMode == MainPageMode.browse ? TextDecoration.underline : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        Expanded(
          child: Material(
            type: mainPageMode == MainPageMode.activities ? MaterialType.circle : MaterialType.transparency,
            color: AppTheme.darkdarkGrey,
            child: InkResponse(
              onTap: mainPageMode != MainPageMode.activities
                  ? () => setState(() {
                        mainPageMode = MainPageMode.activities;
                      })
                  : null,
              child: SizedBox(
                height: 84.0,
                width: 84.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 5.0),
                        child: InfAssetImage(
                          AppIcons.inbox,
                          width: 20.0,
                        ),
                      ),
                      Text(
                        'ACTIVITIES',
                        style: TextStyle(
                          fontSize: 10.0,
                          decoration:
                              mainPageMode == MainPageMode.activities ? TextDecoration.underline : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}
