/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:inf/network_generic/multi_account_client.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/widgets/blurred_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({
    Key key,
    this.size,
    this.localAccount,
    this.account,
    this.tag = '',
  }) : super(key: key);

  final double size;
  final DataAccount account;
  final LocalAccountData localAccount;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: size,
      height: size,
      child: new Hero(
        tag: (account?.summary?.avatarThumbnailUrl ?? localAccount?.avatarUrl) +
            tag,
        child: new Material(
          type: MaterialType.circle,
          elevation: 0.0,
          color: Colors.transparent,
          child: new ClipOval(
            child: new BlurredNetworkImage(
              fit: BoxFit.fill,
              blurredUrl: account?.summary?.blurredAvatarThumbnailUrl ??
                  localAccount?.blurredAvatarUrl,
              url: account?.summary?.avatarThumbnailUrl ??
                  localAccount?.avatarUrl,
              placeholderAsset:
                  (account?.state?.accountType ?? localAccount?.accountType) ==
                          AccountType.influencer
                      ? 'assets/default_avatar_influencer.png'
                      : 'assets/default_avatar_business.png',
            ),
          ),
        ),
      ),
    );
  }
}

/* end of file */
