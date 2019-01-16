import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/user_profile/profile_private_page.dart';
import 'package:inf/ui/user_profile/profile_summery.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_switch.dart';

import 'package:inf_api_client/inf_api_client.dart';

class MainNavigationDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final userManager = backend.get<UserManager>();

    List<Widget> buildColumnEntries(User currentUser) {
      List<Widget> entries = <Widget>[]..addAll([
          Text(
            'VISIBILITY',
            textAlign: TextAlign.left,
            style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
          ),
          SizedBox(height: 8),
          _MainNavigationItem(
            icon: InfAssetImage(
              AppIcons.directOffers,
              color: Colors.white,
            ),
            text: 'Allow direct offers',
            trailing: InfSwitch(
              value: currentUser.acceptsDirectOffers,
              onChanged: (val) {
                userManager.updateUserCommand(
                  currentUser.copyWith((user) => user.acceptsDirectOffers = val),
                );
              },
              activeColor: AppTheme.blue,
            ),
          ),
          _MainNavigationItem(
            icon: InfAssetImage(
              AppIcons.location,
              color: Colors.white,
            ),
            text: 'Show my location',
            trailing: InfSwitch(
              value: currentUser.showLocation,
              onChanged: (val) {
                userManager.updateUserCommand(
                  currentUser.copyWith((user) => user.showLocation = val),
                );
              },
              activeColor: AppTheme.blue,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'PAYMENT',
            textAlign: TextAlign.left,
            style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
          ),
          SizedBox(height: 8),
          _MainNavigationItem(
            icon: InfAssetImage(
              AppIcons.payments,
              color: Colors.white,
            ),
            text: 'Payment settings',
            onTap: () {},
          ),
          _MainNavigationItem(
            icon: InfAssetImage(
              AppIcons.earnings,
              color: Colors.white,
            ),
            text: 'Earnings',
            onTap: () {},
          ),
          SizedBox(height: 16),
          Text(
            'SETTINGS',
            textAlign: TextAlign.left,
            style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
          ),
          SizedBox(height: 8),
          _MainNavigationItem(
            icon: InfAssetImage(
              AppIcons.switchUser,
              color: Colors.white,
            ),
            text: 'Accounts',
            onTap: () {},
          ),
        ]);
      return entries;
    }

    return Material(
      color: AppTheme.listViewAndMenuBackground,
      elevation: 8.0,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: InfAssetImage(
              AppImages.mockCurves, // FIXME:
              alignment: Alignment.bottomCenter,
            ),
          ),

          ListView(
            primary: false,
            padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom + 12.0),
            children: [
              ProfileSummery(
                user: userManager.currentUser,
                heightTotalPercentage: 0.48,
                gradientStop: 0.3,
                showDescription: true,
                showSocialMedia: true,
              ),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 24.0, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildColumnEntries(userManager.currentUser),
                ),
              ),
            ],
          ),

          // View profile button
          Positioned(
            height: 35,
            right: 0.0,
            top: 50.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(16.0),
                  bottomStart: Radius.circular(16.0),
                ),
                color: const Color(0x85000000),
              ),
              alignment: Alignment.centerRight,
              child: FlatButton(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                onPressed: ()  {
                   Navigator.of(context).push(ProfilePrivatePage.route());
                },
                child: Text(
                  'View profile',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
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
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6.0),
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.white12),
                child: Center(
                  child: icon,
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                text,
                style: const TextStyle(fontSize: 18.0),
              ),
              Spacer(),
              trailing != null ? trailing : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}


