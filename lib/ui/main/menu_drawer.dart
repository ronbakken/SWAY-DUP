import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:pedantic/pedantic.dart';

class MainNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userManager = backend.get<UserManager>();
    return Material(
      elevation: 8.0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: <Widget>[
              Text(userManager.isLoggedIn ? userManager.currentUser.name : ''),
              SizedBox(height: 10),
              _MainNavigationItem(
                icon: AppIcons.browse,
                text: 'Browse',
                onTap: () {},
              ),
              SizedBox(height: 10),
              _MainNavigationItem(
                icon: AppIcons.history,
                text: 'History',
                onTap: () {},
              ),
              SizedBox(height: 10),
              _MainNavigationItem(
                icon: AppIcons.offers,
                text: 'Offers',
                onTap: () {},
                trailing: CircleAvatar(radius: 8.0),
              ),
              SizedBox(height: 10),
              _MainNavigationItem(
                icon: AppIcons.directOffers,
                text: 'Direct',
                onTap: () {},
              ),
              SizedBox(height: 10),
              _MainNavigationItem(
                icon: AppIcons.deals,
                text: 'Deal',
                onTap: () {},
              ),
              SizedBox(height: 30),
              _MainNavigationItem(
                icon: AppIcons.menu,
                text: 'Logout',
                onTap: () async {
                  await backend.get<AuthenticationService>().logOut();
                  unawaited(Navigator.of(context).pushAndRemoveUntil(
                      WelcomePage.route(), (route) => false));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainNavigationItem extends StatelessWidget {
  const _MainNavigationItem({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onTap,
    this.trailing,
  }) : super(key: key);

  final AppAsset icon;
  final String text;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
        ),
      ),
    );
  }
}
