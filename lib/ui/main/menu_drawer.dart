import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_switch.dart';
import 'package:pedantic/pedantic.dart';

class MainNavigationDrawer extends StatelessWidget {
  void setSocialMediaAccountState(SocialMediaAccount account, bool isActive) {
    backend.get<UserManager>().updateSocialMediaAccountCommand(account.copyWith(isActive: isActive));
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final userManager = backend.get<UserManager>();
    final isLoggedIn = userManager.isLoggedIn;

    List<Widget> buildColumnEntries(User currentUser) {
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
            style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
          ),
          SizedBox(height: 8),
        ]);

      for (var account in currentUser.socialMediaAccounts) {
        entries.add(_MainNavigationItem(
          icon: InfMemoryImage(account.socialNetWorkProvider.logoMonochromeData, height: 20, ),
          text: account.socialNetWorkProvider.name,
          trailing: InfSwitch(
            value: account.isActive,
            onChanged: (val) => setSocialMediaAccountState(account, val),
            activeColor: AppTheme.blue,
          ),
        ));
      }

      entries.addAll([
        SizedBox(height: 8),
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
                currentUser.copyWith(acceptsDirectOffers: val),
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
                currentUser.copyWith(showLocation: val),
              );
            },
            activeColor: AppTheme.blue,
          ),
        ),
        SizedBox(height: 8),
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
      return entries;
    }

    return Material(
      color: AppTheme.listViewAndMenuBackground,
      elevation: 8.0,
      child: StreamBuilder<User>(
        initialData: userManager.currentUser,
        stream: userManager.currentUserUpdates,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          }
          var currentUser = snapshot.data;
          return ListView(
            primary: false,
            padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom + 12.0),
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.2 + mediaQuery.padding.top,
                child: isLoggedIn
                    ? CurvedBoxClip(
                        bottom: true,
                        child: InfImage(
                          fit: BoxFit.fitWidth,
                          lowRes: currentUser.avatarLowRes,
                          imageUrl: currentUser.avatarUrl,
                        ),
                      )
                    : SizedBox(),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(16.0),
                    bottomStart: Radius.circular(16.0),
                  ),
                  color: AppTheme.menuUserNameBackground,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          isLoggedIn ? currentUser.name : 'Please sign up',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InfAssetImage(
                        AppIcons.edit,
                        width: 24,
                        height: 24,
                      )
                    ],
                  ),
                ),
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
