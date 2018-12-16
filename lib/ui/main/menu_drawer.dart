import 'dart:math';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_switch.dart';
import 'package:inf_common/inf_common.dart';
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
    @required this.onLogOut,
  }) : super(key: key);

  final ConfigData config;
  final DataAccount account;

  final void Function() onNavigateProfile;
  final void Function() onNavigateHistory;
  final void Function() onNavigateSwitchAccount;
  final void Function() onNavigateDebugAccount;

  final void Function(DataAccount account) onEditAccount;
  final void Function(DataSocialMedia socialMedia) onEditSocialMedia;

  final void Function() onLogOut;

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
      final List<Widget> entries = <Widget>[
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
      ];
      for (DataSocialMedia socialMedia in currentUser.socialMedia.values) {
        if (socialMedia.connected) {
          final ConfigOAuthProvider oauthProvider =
              config.oauthProviders[socialMedia.providerId];
          if (oauthProvider?.visible == true) {
            entries.add(_MainNavigationItem(
              icon: InfMemoryImage(
                oauthProvider.monochromeForegroundImage,
                height: 32,
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
          'DEVELOPMENT',
          textAlign: TextAlign.left,
          style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
        ),
        SizedBox(height: 8),
          FlatButton(
            child: Row(children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                child: const Icon(Icons.account_circle),
              ),
              const Text('Profile')
            ]),
            onPressed: (onNavigateProfile != null)
                ? () {
                    Navigator.pop(context);
                    onNavigateProfile();
                  }
                : null,
          ),
          FlatButton(
            child: Row(children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                child: const Icon(Icons.history),
              ),
              const Text('History')
            ]),
            onPressed: (onNavigateHistory != null)
                ? () {
                    Navigator.pop(context);
                    onNavigateHistory();
                  }
                : null,
          ),
          FlatButton(
            child: Row(children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                child: const Icon(Icons.supervisor_account),
              ),
              const Text('Switch User')
            ]),
            onPressed: (onNavigateSwitchAccount != null)
                ? () {
                    Navigator.pop(context);
                    onNavigateSwitchAccount();
                  }
                : null,
          ),
          (account.globalAccountState.value >= GlobalAccountState.debug.value)
              ? FlatButton(
                  child: Row(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: const Icon(Icons.account_box),
                    ),
                    const Text('Debug Account')
                  ]),
                  onPressed: (onNavigateDebugAccount != null)
                      ? () {
                          Navigator.pop(context);
                          onNavigateDebugAccount();
                        }
                      : null,
                )
              : null,
        ].where((Widget w) => w != null));
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
                    account.freeze();
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
                    account.freeze();
                    onEditAccount(account);
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
        SizedBox(height: 30),
        _MainNavigationItem(
          icon: InfAssetImage(AppIcons.menu),
          text: 'Logout',
          onTap: onLogOut,
        ),
      ]);
      return entries;
    }

    return Material(
      color: AppTheme.listViewAndMenuBackground,
      elevation: 8.0,
      child: ListView(
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
                      lowRes:
                          kTransparentImage, // TODO(kaetemi): account.avatarBlurred,
                      imageUrl: account.avatarUrl,
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
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 24.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildColumnEntries(account),
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
