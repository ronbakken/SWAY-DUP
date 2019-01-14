import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/user_manager_.dart';
import 'package:inf/ui/user_profile/edit_profile_page.dart';
import 'package:inf/ui/user_profile/profile_business_view.dart';
import 'package:inf/ui/user_profile/profile_influencer_view.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

import 'package:inf/ui/widgets/routes.dart';
import 'package:inf_api_client/inf_api_client.dart';

class ProfilePrivatePage extends StatelessWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) => ProfilePrivatePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userManager = backend.get<UserManager>();

    return Material(color: AppTheme.blackTwo,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: StreamBuilder<User>(
                initialData: userManager.currentUser,
                stream: userManager.currentUserUpdates,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  }
                  User user = snapshot.data;
                  if (user.userType == UserType.influencer) {
                    return ProfileInfluencerView(user: user);
                  } else {
                    return ProfileBusinessView(user: user);
                  }
                }),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  InkResponse(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 32,
                    ),
                  ),
                  Spacer(),
                  InkResponse(
                    onTap: () => Navigator.of(context).push(EditProfilePage.route()),
                    child: InfAssetImage(
                      AppIcons.edit,
                      width: 32,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
