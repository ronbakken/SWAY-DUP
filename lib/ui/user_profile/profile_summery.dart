import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/user.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';

class ProfileSummery extends StatelessWidget {
  final User user;
  final bool showSocialMedia;
  final bool showDescription;
  final double heightTotalPercentage;
  final double heightImagePercentage;
  final double gradientStop;
  final bool showOnlyImage;

  const ProfileSummery({
    @required this.user,
    this.showSocialMedia = false,
    this.showDescription = false,
    this.heightTotalPercentage = 0.48,
    this.heightImagePercentage = 0.85,
    this.gradientStop = 0.75,
    this.showOnlyImage = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    var rowItems = <Widget>[];
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
              child: InfImage(
                fit: BoxFit.fitHeight,
                lowRes: user.avatarLowRes,
                imageUrl: user.avatarUrl,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, AppTheme.blackTwo],
                      begin: Alignment(0, 0.2),
                      end: Alignment.bottomCenter,
                      stops: [0.0, gradientStop])),
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
                        Text(user.locationAsString),
                        SizedBox(height: 8.0),

                        // Dynamically update the social media icons
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
        ));
  }
}
