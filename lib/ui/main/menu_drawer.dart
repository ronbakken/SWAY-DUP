import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_switch.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:pedantic/pedantic.dart';

class MainNavigationDrawer extends StatelessWidget {
  void setSocialMediaAccountState(SocialMediaAccount account, bool isActive) {
    backend
        .get<UserManager>()
        .updateSocialMediaAccountCommand(account.copyWith((account) => account.isActive = isActive));
  }

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
          StreamBuilder<User>(
            initialData: userManager.currentUser,
            stream: userManager.currentUserUpdates,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              User currentUser = snapshot.data;
              return ListView(
                primary: false,
                padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom + 12.0),
                children: [
                  buildProfileArea(mediaQuery, currentUser),
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 24.0, right: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buildColumnEntries(currentUser),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  SizedBox buildProfileArea(MediaQueryData mediaQuery, User currentUser) {
    return SizedBox(
        height: mediaQuery.size.height * 0.48 + mediaQuery.padding.top,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0.0,
              right: 0.0,
              height: mediaQuery.size.height * 0.43 + mediaQuery.padding.top,
              child: InfImage(
                fit: BoxFit.fitHeight,
                lowRes: currentUser.avatarLowRes,
                imageUrl: currentUser.avatarUrl,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      begin: Alignment(0, -0.3),
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.8])),
            ),
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
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Text(
                    'Edit profile',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0.0,
              right: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    currentUser.name,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(currentUser.locationAsString),
                  SizedBox(height: 8.0),
                  StreamBuilder<List<SocialMediaAccountWrapper>>(
                    stream: backend.get<UserManager>().getSocialMediaAccounts(),
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        var rowItems = <Widget>[];
                        for (var account in snapShot.data) {
                          rowItems.add(
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InfMemoryImage(
                                account.monoChromeIcon,
                                height: 20.0,
                              ),
                            ),
                          );
                        }
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: rowItems,
                        );
                      } else {
                        return SizedBox(height: 20);
                      }
                    },
                  ),
                  SizedBox(height: 8.0),
                  Text(currentUser.description),
                  SizedBox(
                    height: 16.0,
                  )
                ],
              ),
            )
          ],
        ));
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

// for (var account in currentUser.socialMediaAccounts) {
//   var provider=backend.get<ConfigService>().getSocialNetworkProviderById(account.socialNetworkProviderId);
//   entries.add(_MainNavigationItem(
//     icon: InfMemoryImage(provider.logoMonochromeData, height: 20, ),
//     text: provider.name,
//     trailing: InfSwitch(
//       value: account.isActive,
//       onChanged: (val) => setSocialMediaAccountState(account, val),
//       activeColor: AppTheme.blue,
//     ),
//   ));
// }
