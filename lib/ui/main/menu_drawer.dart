import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/user_profile/profile_summary.dart';
import 'package:inf/ui/user_profile/switch_user_dialog.dart';
import 'package:inf/ui/user_profile/view_profile_page.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_loader.dart';
import 'package:inf/ui/widgets/inf_switch.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:rx_command/rx_command.dart';

class MainNavigationDrawer extends StatefulWidget {
  @override
  MainNavigationDrawerState createState() {
    return MainNavigationDrawerState();
  }
}

class MainNavigationDrawerState extends State<MainNavigationDrawer> {
  RxCommandListener<UserUpdateData, void> updateUserListener;
  RxCommandListener<void, void> logOutUserListener;

  @override
  void initState() {
    super.initState();
    updateUserListener = RxCommandListener(backend<UserManager>().updateUserCommand,
        onIsBusy: () => InfLoader.show(context),
        onNotBusy: () => InfLoader.hide(),
        onError: (error) {
          backend<ErrorReporter>().logException(error);
          showMessageDialog(
            context,
            'Update Problem',
            'Sorry we had a problem update your user\'s settings. Please try again later',
          );
        });

    logOutUserListener = RxCommandListener(backend<UserManager>().logOutUserCommand, onValue: (_) {
      return Navigator.of(context).pushAndRemoveUntil(WelcomePage.route(), (_) => false);
    }, onError: (error) {
      backend<ErrorReporter>().logException(error);
      showMessageDialog(
        context,
        'Logout Problem',
        'Sorry we had a problem logging you out. Please try again later',
      );
    });
  }

  @override
  void dispose() {
    updateUserListener?.dispose();
    logOutUserListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final userManager = backend<UserManager>();

    List<Widget> buildColumnEntries(User currentUser) {
      List<Widget> entries = <Widget>[]..addAll([
          const Text(
            'VISIBILITY',
            textAlign: TextAlign.left,
            style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
          ),
          verticalMargin8,
          _MainNavigationItem(
            icon: const InfAssetImage(AppIcons.directOffers, color: Colors.white),
            text: 'Allow direct offers',
            trailing: InfSwitch(
              value: currentUser.acceptsDirectOffers,
              onChanged: (val) {
                userManager.updateUserCommand(
                  UserUpdateData(user: currentUser.copyWith(acceptsDirectOffers: val)),
                );
              },
              activeColor: AppTheme.blue,
            ),
          ),
          _MainNavigationItem(
            icon: const InfAssetImage(AppIcons.location, color: Colors.white),
            text: 'Show my location',
            trailing: InfSwitch(
              value: currentUser.showLocation,
              onChanged: (val) {
                userManager.updateUserCommand(
                  UserUpdateData(user: currentUser.copyWith(showLocation: val)),
                );
              },
              activeColor: AppTheme.blue,
            ),
          ),
          verticalMargin16,
          const Text(
            'PAYMENT',
            textAlign: TextAlign.left,
            style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
          ),
          verticalMargin8,
          _MainNavigationItem(
            icon: const InfAssetImage(AppIcons.value, color: Colors.white),
            text: 'Payment settings',
            onTap: () {},
          ),
          _MainNavigationItem(
            icon: const InfAssetImage(AppIcons.earnings, color: Colors.white),
            text: 'Earnings',
            onTap: () {},
          ),
          verticalMargin16,
          const Text(
            'SETTINGS',
            textAlign: TextAlign.left,
            style: const TextStyle(color: AppTheme.white30, fontSize: 20.0),
          ),
          verticalMargin8,
          _MainNavigationItem(
            icon: const InfAssetImage(
              AppIcons.switchUser,
              color: Colors.white,
            ),
            text: 'Profiles',
            onTap: switchProfile,
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
          const Align(
            alignment: Alignment.bottomCenter,
            child: CustomAnimatedCurves(),
          ),
          StreamBuilder<User>(
              initialData: userManager.currentUser,
              stream: userManager.currentUserUpdates,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return emptyWidget;
                }
                var user = snapshot.data;
                return ListView(
                  primary: false,
                  padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom + 12.0),
                  children: [
                    ProfileSummary(
                      user: user,
                      heightTotalPercentage: 0.48,
                      gradientStop: 0.3,
                      showDescription: true,
                      showSocialMedia: true,
                    ),
                    verticalMargin16,
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 24.0, right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: buildColumnEntries(user),
                      ),
                    ),
                  ],
                );
              }),

          // View profile button
          Positioned(
            height: 35,
            right: 0.0,
            top: 50.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(16.0),
                  bottomStart: Radius.circular(16.0),
                ),
                color: const Color(0x85000000),
              ),
              alignment: Alignment.centerRight,
              child: FlatButton(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                onPressed: () {
                  Navigator.of(context).push(ViewProfilePage.route(userManager.currentUser));
                },
                child: const Text(
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

  void switchProfile() async {
    var profiles = backend<UserManager>().getLoginProfiles();
    var selectedProfile = await showDialog<LoginProfile>(
        context: context,
        builder: (context) => SwitchUserDialog(
              profiles: profiles,
            ));
    if (selectedProfile == null) {
      return;
    }
    if (selectedProfile.email == 'LOGOUT') {
      backend<UserManager>().logOutUserCommand();
    }
    backend<UserManager>().switchUserCommand(selectedProfile);
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
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.white12),
                child: Center(
                  child: icon,
                ),
              ),
              horizontalMargin8,
              Text(
                text,
                style: const TextStyle(fontSize: 18.0),
              ),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}
