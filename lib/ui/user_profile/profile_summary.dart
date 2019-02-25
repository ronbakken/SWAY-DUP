import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/user.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';

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

    var rowItems = <Widget>[];
    if (showSocialMedia) {
      for (var socialMediaAccount in user.socialMediaAccounts) {
        rowItems.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InfMemoryImage(
              socialMediaAccount.socialNetWorkProvider.logoMonochromeData,
              height: 20.0,
            ),
          ),
        );
      }
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
            child: imageFile == null
                ? InfImage(
                    fit: BoxFit.fitHeight,
                    lowResUrl: user.avatarImage.lowresUrl,
                    imageUrl: user.avatarImage.imageUrl,
                  )
                : Image.file(imageFile, fit: BoxFit.fitHeight),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.transparent, AppTheme.blackTwo],
                  begin: Alignment(0, 0.2),
                  end: Alignment.bottomCenter,
                  stops: [0.0, gradientStop]),
            ),
          ),
          !showOnlyImage
              ? Positioned(
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
                      SizedBox(height: 4.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(user.locationAsString),
                      ),
                      SizedBox(height: 8.0),
                      showSocialMedia
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: rowItems,
                            )
                          : SizedBox(),
                      showDescription
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                              child: Text(
                                user.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 8.0)
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
