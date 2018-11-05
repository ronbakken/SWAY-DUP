import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/auth_state_listener_mixin.dart';
import 'package:inf/ui/widgets/connection_builder.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';

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
  TabController tabController;

  _MainPageState() {
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionBuilder(builder: (context, connectionState) {
      return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkResponse(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: SvgPicture.asset('assets/images/menu_icon.svg'),
                  ),
                ),
          ),
          centerTitle: true,
          title: SvgPicture.asset(
            'assets/images/INF.svg',
            height: 33.8,
            fit: BoxFit.fill,
            allowDrawingOutsideViewBox: true,
          ),
        ),
        body: buildBody(),
        bottomNavigationBar: buildNavigationBar(),
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
            icon: SvgPicture.asset(
              'assets/images/chat_icon.svg',
              height: 30.0,
            )),
        BottomNavigationBarItem(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Proposals'),
          ),
          icon: SvgPicture.asset('assets/images/proposal_icon.svg', height: 30.0),
        ),
        BottomNavigationBarItem(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Agreements'),
          ),
          icon: SvgPicture.asset('assets/images/agreements.svg', height: 30.0),
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
          buildMenuRow('assets/images/proposal_icon.svg', 'Browse', () {}),
          SizedBox(height: 10),
          buildMenuRow('assets/images/proposal_icon.svg', 'History', () {}),
          SizedBox(height: 10),
          buildMenuRow('assets/images/proposal_icon.svg', 'Offers', () {}, CircleAvatar(radius: 8.0)),
          SizedBox(height: 10),
          buildMenuRow('assets/images/proposal_icon.svg', 'Direct', () {}),
          SizedBox(height: 10),
          buildMenuRow('assets/images/proposal_icon.svg', 'Deal', () {}),
        ],
      ),
    );
  }

  Widget buildMenuRow(String svgPath, String text, GestureTapCallback onTap, [Widget trailing]) {
    return InkWell(
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            svgPath,
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
    return Column(
      children: <Widget>[
        Text('Influencer MainPage'),
        TabBar(
          controller: tabController,
          tabs: <Widget>[Text('MAP'), Text('BROWSE')],
        ),
        Expanded(
                  child: TabBarView(controller: tabController,
          children: <Widget>[
            
          ],
      
          ),
        )
      ],
    );
  }

}


