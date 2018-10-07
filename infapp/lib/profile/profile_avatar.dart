import 'package:flutter/material.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/widgets/blurred_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({
    Key key,
    this.size,
    this.account,
    this.tag = '',
  }) : super(key: key);

  final double size;
  final DataAccount account;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: size,
      height: size,
      child: new Hero(
        tag: account.summary.avatarThumbnailUrl + tag,
        child: new Material(
          type: MaterialType.circle,
          elevation: 0.0,
          color: Colors.transparent,
          child: new ClipOval(
            child: new BlurredNetworkImage(
              fit: BoxFit.fill,
              blurredUrl: account.summary.blurredAvatarThumbnailUrl,
              url: account.summary.avatarThumbnailUrl,
              placeholderAsset:
                  account.state.accountType == AccountType.AT_INFLUENCER
                      ? 'assets/default_avatar_influencer.png'
                      : 'assets/default_avatar_business.png',
            ),
          ),
        ),
      ),
    );
  }
}
