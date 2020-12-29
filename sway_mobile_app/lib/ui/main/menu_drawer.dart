import 'dart:math';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:sway_mobile_app/app/assets.dart';
import 'package:sway_mobile_app/app/theme.dart';
import 'package:sway_mobile_app/ui/user_profile/profile_summary.dart';
import 'package:sway_mobile_app/ui/welcome/welcome_page.dart';
import 'package:sway_mobile_app/ui/widgets/animated_curves.dart';
import 'package:sway_mobile_app/ui/widgets/curved_box.dart';
import 'package:sway_mobile_app/ui/widgets/inf_asset_image.dart';
import 'package:sway_mobile_app/ui/widgets/inf_image.dart';
import 'package:sway_mobile_app/ui/widgets/inf_memory_image.dart';
import 'package:sway_mobile_app/ui/widgets/inf_switch.dart';
import 'package:sway_common/inf_common.dart';
// import 'package:pedantic/pedantic.dart';
import 'package:transparent_image/transparent_image.dart';

class MainNavigationDrawer extends StatelessWidget {
  const MainNavigationDrawer({
    Key key,
    @required this.config,
    @required this.account,
    @required this.onNavigateProfile,
    @required this.onNavigateHistory,
    @required this.onNavigateSwitchAccount,
    @required this.onNavigateDebugAccount,
    @required this.onEditAccount,
    @required this.onEditSocialMedia,
  }) : super(key: key);

  final ConfigData config;
  final DataAccount account;

  final void Function() onNavigateProfile;
  final void Function() onNavigateHistory;
  final void Function() onNavigateSwitchAccount;
  final void Function() onNavigateDebugAccount;

  final void Function(DataAccount account) onEditAccount;
  final void Function(DataSocialMedia socialMedia) onEditSocialMedia;

  void setSocialMediaAccountState(int providerId, bool published) {
    final DataSocialMedia socialMedia = DataSocialMedia();
    socialMedia.providerId = providerId;
    socialMedia.published = published;
    socialMedia.freeze();
    onEditSocialMedia(socialMedia);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final bool isLoggedIn = account.accountId != Int64.ZERO;
    List<Widget> buildColumnEntries(DataAccount currentUser) {
      final List<Widget> entries = <Widget>[];
      entries.addAll(<Widget>[
        _MainNavigationItem(
          icon: const Icon(Icons.account_circle),
          text: 'Profile',
          onTap: onNavigateProfile,
        ),
        _MainNavigationItem(
          icon: const Icon(Icons.history),
          text: 'History',
          onTap: onNavigateHistory,
        ),
        (account.globalAccountState.value >= GlobalAccountState.debug.value)
            ? _MainNavigationItem(
                icon: const Icon(Icons.account_box),
                text: 'Debug Account',
                onTap: onNavigateDebugAccount,
              )
            : null,
      ].where((Widget w) => w != null));
      entries.addAll(<Widget>[
        _MainNavigationItem(
          icon: const InfAssetImage(
            AppIcons.switchUser,
            color: Colors.white,
          ),
          text: 'Switch Account',
          onTap: onNavigateSwitchAccount,
        ),
        const SizedBox(height: 16),
        const Text(
          'SOCIAL MEDIA ACCOUNTS',
          textAlign: TextAlign.left,
          style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
        ),
        const SizedBox(height: 8),
      ]);
      for (DataSocialMedia socialMedia in currentUser.socialMedia.values) {
        if (socialMedia.connected) {
          final ConfigOAuthProvider oauthProvider =
              config.oauthProviders[socialMedia.providerId];
          if (oauthProvider?.visible == true) {
            entries.add(_MainNavigationItem(
              icon: InfMemoryImage(
                oauthProvider.monochromeForegroundImage ?? kTransparentImage,
                height: 20,
              ),
              text: oauthProvider.label,
              trailing: InfSwitch(
                value: socialMedia.published,
                onChanged: onEditSocialMedia == null
                    ? null
                    : (bool value) => setSocialMediaAccountState(
                        socialMedia.providerId, value),
                activeColor: AppTheme.blue,
              ),
            ));
          }
        }
      }
      entries.addAll(<Widget>[
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
            value: currentUser.acceptDirectProposals,
            onChanged: onEditAccount == null
                ? null
                : (bool value) {
                    final DataAccount account = DataAccount();
                    account.acceptDirectProposals = value;
                    //account.freeze();
                    onEditAccount(account);
                  },
            activeColor: AppTheme.blue,
          ),
        ),
        _MainNavigationItem(
          icon: InfAssetImage(
            AppIcons.location,
            color: Colors.white,
          ),
          text: 'Share my location',
          trailing: InfSwitch(
            value: currentUser.publishGpsLocation,
            onChanged: onEditAccount == null
                ? null
                : (bool value) {
                    final DataAccount account = DataAccount();
                    account.publishGpsLocation = value;
                    //account.freeze();
                    onEditAccount(account);
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
          onTap: null, // TODO
        ),
        _MainNavigationItem(
          icon: InfAssetImage(
            AppIcons.earnings,
            color: Colors.white,
          ),
          text: 'Earnings',
          onTap: null, // TODO
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
          text: 'Switch Account',
          onTap: onNavigateSwitchAccount,
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
            child: CustomAnimatedCurves(),
          ),
          ListView(
            primary: false,
            padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom + 12.0),
            children: <Widget>[
              ProfileSummary(
                config: config,
                account: account,
                heightTotalPercentage: 0.48,
                gradientStop: 0.3,
                showDescription: true,
                showSocialMedia: true,
              ),
              /*
              SizedBox(
                height: mediaQuery.size.height * 0.2 + mediaQuery.padding.top,
                child: isLoggedIn
                    ? CurvedBoxClip(
                        bottom: true,
                        child: InfImage(
                          fit: BoxFit.fitWidth,
                          lowRes:
                              kTransparentImage, // TODO(kaetemi): account.avatarBlurred,
                          imageUrl: account.avatarUrl,
                        ),
                      )
                    : SizedBox(),
              ),
              */
              SizedBox(
                height: 16.0,
              ),
              /*
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
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          isLoggedIn ? account.name : 'Anonymous',
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
              */
              Padding(
                padding:
                    const EdgeInsets.only(top: 20, left: 24.0, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildColumnEntries(account),
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
                onPressed: () {
                  // TODO: Navigator.of(context).push(ProfilePrivatePage.route());
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
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppTheme.white12),
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
