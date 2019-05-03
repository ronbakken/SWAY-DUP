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

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({
    Key key,
    @required this.user,
  }) : super(key: key);

  static Route<dynamic> route(User user) {
    return FadePageRoute(
      builder: (BuildContext context) => ViewProfilePage(user: user),
    );
  }

  final User user;

  @override
  ViewProfilePageState createState() => ViewProfilePageState();
}

class ViewProfilePageState extends State<ViewProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userManager = backend<UserManager>();

    // FIXME: use listen API for user profile

    Widget content;
    if (widget.user == userManager.currentUser) {
      content = StreamBuilder<User>(
        initialData: widget.user,
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
      );
    } else {
      content = FutureBuilder<User>(
        initialData: widget.user,
        future: userManager.getUser(widget.user.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.userType == UserType.influencer) {
              return ProfileInfluencerView(user: snapshot.data);
            } else {
              return ProfileBusinessView(user: snapshot.data);
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return loadingWidget;
          }
        },
      );
    }

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
              widget.user == userManager.currentUser
                  ? IconButton(
                      padding: const EdgeInsets.all(16.0),
                      iconSize: 32.0,
                      icon: const InfAssetImage(AppIcons.edit),
                      onPressed: () => Navigator.of(context).push(EditProfilePage.route()),
                    )
                  : emptyWidget,
            ],
          ),
        ),
        child: content,
      ),
    );
  }
}
