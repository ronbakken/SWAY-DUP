import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_switch.dart';
import 'package:pedantic/pedantic.dart';
import 'package:flutter/cupertino.dart' as cupertino;

class MainNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final userManager = backend.get<UserManager>();
    final currentUser = backend.get<UserManager>().currentUser;
    final isLoggedIn = userManager.isLoggedIn;

    List<Widget> entries = <Widget>[]..addAll([
        _MainNavigationItem(
          icon: InfAssetImage(
            AppIcons.switchUser,
            color: Colors.white,
          ),
          text: 'Accounts',
          onTap: () {},
        ),
        SizedBox(height: 16),
        Text(
          'SOCIAL MEDIA ACCOUNTS',
          textAlign: TextAlign.left,
          style: const TextStyle(color: AppTheme.white30, fontSize: 16.0),
        )
      ]);
    for (var account in currentUser.socialMediaAccounts) {
      entries.add(_MainNavigationItem(
        icon: account.isVectorLogo
            ? SvgPicture.memory(
                account.logoData,
              )
            : Image.memory(account.logoData),
        text: account.channelName,
        trailing: InfSwitch(
          value: account.isActive,
          onChanged: (val) {},
          activeColor: AppTheme.blue,
        ),
      ));
    }

    entries.addAll([
      SizedBox(height: 8),
      Text(
        'VISIBILITY',
        textAlign: TextAlign.left,
        style: const TextStyle(color: AppTheme.white30, fontSize: 16.0),
      ),
      SizedBox(height: 8),
      _MainNavigationItem(
        icon: InfAssetImage(
          AppIcons.directOffers,
          color: Colors.white,
        ),
        text: 'Send me direct offers',
        onTap: () {},
        trailing: InfSwitch(
          value: true,
          onChanged: (val) {},
          activeColor: AppTheme.blue,
        ),
      ),
      _MainNavigationItem(
        icon: InfAssetImage(
          AppIcons.location,
          color: Colors.white,
        ),
        text: 'Show my location',
        onTap: () {},
        trailing: InfSwitch(
          value: true,
          onChanged: (val) {},
          activeColor: AppTheme.blue,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'PAYMENT',
        textAlign: TextAlign.left,
        style: const TextStyle(color: AppTheme.white30, fontSize: 16.0),
      ),
      SizedBox(height: 8),
      _MainNavigationItem(
        icon: InfAssetImage(
          AppIcons.payments,
          color: Colors.white,
        ),
        text: 'Payment settings',
        onTap: () {},
        trailing: InfSwitch(
          value: true,
          onChanged: (val) {},
          activeColor: AppTheme.blue,
        ),
      ),
      _MainNavigationItem(
        icon: InfAssetImage(
          AppIcons.directOffers,
          color: Colors.white,
        ),
        text: 'Earnings',
        onTap: () {},
        trailing: InfSwitch(
          value: true,
          onChanged: (val) {},
          activeColor: AppTheme.blue,
        ),
      ),
      SizedBox(height: 30),
      _MainNavigationItem(
        icon: InfAssetImage(AppIcons.menu),
        text: 'Logout',
        onTap: () async {
          await backend.get<AuthenticationService>().logOut();
          unawaited(Navigator.of(context).pushAndRemoveUntil(WelcomePage.route(), (route) => false));
        },
      ),
    ]);

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
                child: ClipPath(
                  clipper: _ProfilePictureClipper(),
                  child: isLoggedIn
                      ? InfImage(
                          fit: BoxFit.fitWidth,
                          lowRes: currentUser.avatarLowRes,
                          imageUrl: currentUser.avatarUrl,
                        )
                      : SizedBox(),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 24),
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
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 24.0, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: entries,
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
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final Widget icon;
  final String text;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.darkGrey,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.white12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: icon,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Text(text),
              Spacer(),
              trailing != null ? trailing : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfilePictureClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
     double curveFactor = size.height * 0.9;
    final path = Path()..addArc(Rect.fromLTRB(-curveFactor, -size.height, size.width + curveFactor, size.height), 0, pi);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
