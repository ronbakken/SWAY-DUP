import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inf/ui/widgets/auth_state_listener_mixin.dart';
import 'package:inf/ui/widgets/connection_builder.dart';
import 'package:inf/ui/widgets/routes.dart';

class MainPageInf extends StatefulWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (context) => MainPageInf(),
    );
  }

  @override
  _MainPageInfState createState() => _MainPageInfState();
}

class _MainPageInfState extends State<MainPageInf>
    with AuthStateListenerMixin<MainPageInf>, SingleTickerProviderStateMixin {
  TabController tabController;

  _MainPageInfState() {
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionBuilder(builder: (contex, connectionState) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/images/menu_icon.svg',
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
          bottomNavigationBar: BottomNavigationBar(
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
                  icon: SvgPicture.asset('assets/images/proposal_icon.svg',
                      height: 30.0)),
              BottomNavigationBarItem(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Agreements'),
                  ),
                  icon: SvgPicture.asset('assets/images/agreements.svg',
                      height: 30.0)),
            ],
          ),
        ),
      );
    });
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[
        Text('Influencer MainPage'),
        TabBar(controller: tabController,
          tabs: <Widget>[
            Text(
              'MAP',
            ),
            Text('BROWSE')
          ],
        )
      ],
    );
  }
}
