import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/user.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

/// Shows the profile picture with a black gradient and optional user data and
/// connected social media accounts
class ProfileSummary extends StatelessWidget {
  final User user;
  final bool showSocialMedia;
  final bool showDescription;
  final double heightTotalPercentage;
  final double heightImagePercentage;
  final double gradientStop;
  final bool showOnlyImage;

  /// if [imageFile] is set it will displayed instead of the
  /// image provided with the user object
  final File imageFile;

  const ProfileSummary({
    @required this.user,
    this.showSocialMedia = false,
    this.showDescription = false,
    this.heightTotalPercentage = 0.48,
    this.heightImagePercentage = 0.85,
    this.gradientStop = 0.75,
    this.showOnlyImage = false,
    this.imageFile,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    Widget profileImage;
    if (imageFile != null) {
      profileImage = Image.file(imageFile, fit: BoxFit.fitHeight);
    } else if (user.dataType == UserDto_Data.handle) {
      profileImage = InfImage(
        fit: BoxFit.fitHeight,
        lowResUrl: user.avatarThumbnail.lowResUrl,
        imageUrl: user.avatarThumbnail.imageUrl,
      );
    } else {
      profileImage = InfImage(
        fit: BoxFit.fitHeight,
        lowResUrl: user.avatarImage.lowResUrl,
        imageUrl: user.avatarImage.imageUrl,
      );
    }

    return SizedBox(
      height: mediaQuery.size.height * heightTotalPercentage + mediaQuery.padding.top,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0.0,
            right: 0.0,
            height: mediaQuery.size.height * heightTotalPercentage * heightImagePercentage + mediaQuery.padding.top,
            child: profileImage,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, AppTheme.blackTwo],
                begin: const Alignment(0, 0.2),
                end: Alignment.bottomCenter,
                stops: [0.0, gradientStop],
              ),
            ),
          ),
          if (!showOnlyImage)
            Positioned(
              bottom: 0,
              left: 0.0,
              right: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  verticalMargin4,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(user.locationAsString ?? ''),
                  ),
                  verticalMargin8,
                  if (showSocialMedia)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (showSocialMedia)
                          for (var socialMediaAccount in user.socialMediaAccounts)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: InfAssetImage(
                                  socialMediaAccount.socialNetWorkProvider.logoRawAssetMonochrome,
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ),
                            )
                      ],
                    ),
                  if (showDescription)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                      child: Text(
                        user.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  verticalMargin8,
                ],
              ),
            ),
        ],
      ),
    );
  }
}
