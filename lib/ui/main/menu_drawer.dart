import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:pedantic/pedantic.dart';

class MainNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final userManager = backend.get<UserManager>();
    final currentUser = backend.get<UserManager>().currentUser;
    final isLoggedIn = userManager.isLoggedIn;
    return Material(
      color: AppTheme.darkGrey,
      elevation: 8.0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ListView(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.25,
                child: isLoggedIn
                    ? InfImage(
                        fit: BoxFit.fitWidth,
                        lowRes: currentUser.avatarLowRes,
                        imageUrl: currentUser.avatarUrl,
                      )
                    : SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 32.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(16.0),
                          bottomStart: Radius.circular(16.0),
                        ),
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                isLoggedIn ? currentUser.name : 'Please sign up',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InfAssetImage(
                              AppIcons.edit,
                              width: 16,
                              height: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    _MainNavigationItem(
                      icon: AppIcons.switchUser,
                      text: 'Accounts',
                      onTap: () {},
                    ),
                    Text(
                      'SOCIAL MEDIA ACCOUNTS',
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: AppTheme.white30, fontSize: 16.0),
                    ),
                    _MainNavigationItem(
                      icon: AppIcons.history,
                      text: 'History',
                      onTap: () {},
                    ),
                    SizedBox(height: 10),
                    _MainNavigationItem(
                      icon: AppIcons.history,
                      text: 'History',
                      onTap: () {},
                    ),
                    _MainNavigationItem(
                      icon: AppIcons.history,
                      text: 'History',
                      onTap: () {},
                    ),
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
                        unawaited(Navigator.of(context).pushAndRemoveUntil(WelcomePage.route(), (route) => false));
                      },
                    ),
                  ],
                ),
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
      color: AppTheme.darkGrey,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 32.0,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.blue),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: InfAssetImage(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ),
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
