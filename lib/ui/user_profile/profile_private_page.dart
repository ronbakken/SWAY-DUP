import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/user_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/user_profile/edit_profile_page.dart';
import 'package:inf/ui/user_profile/profile_business_view.dart';
import 'package:inf/ui/user_profile/profile_influencer_view.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf_api_client/inf_api_client.dart';

class ProfilePrivatePage extends StatefulWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) => ProfilePrivatePage(),
    );
  }

  @override
  ProfilePrivatePageState createState() {
    return new ProfilePrivatePageState();
  }
}

class ProfilePrivatePageState extends State<ProfilePrivatePage> {
  @override
  Widget build(BuildContext context) {
    final userManager = backend<UserManager>();

    return Material(
      color: AppTheme.blackTwo,
      child: InfPageScrollView(
        top: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: const EdgeInsets.all(16.0),
                iconSize: 32.0,
                icon: const BackButtonIcon(),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              IconButton(
                padding: const EdgeInsets.all(16.0),
                iconSize: 32.0,
                icon: const InfAssetImage(AppIcons.edit),
                onPressed: () => Navigator.of(context).push(EditProfilePage.route()),
              ),
            ],
          ),
        ),
        child: StreamBuilder<User>(
          initialData: userManager.currentUser,
          stream: userManager.currentUserUpdates,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return emptyWidget;
            }
            User user = snapshot.data;
            if (user.userType == UserType.influencer) {
              return ProfileInfluencerView(user: user);
            } else {
              return ProfileBusinessView(user: user);
            }
          },
        ),
      ),
    );
  }
}
