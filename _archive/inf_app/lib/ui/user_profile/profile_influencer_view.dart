import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/money.dart';
import 'package:inf/ui/user_profile/profile_summary.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/overflow_row.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class ProfileInfluencerView extends StatelessWidget {
  final User user;

  const ProfileInfluencerView({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rowItems = <Widget>[];
    for (var account in user.socialMediaAccounts) {
      rowItems.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 32.0,
              height: 32.0,
              child: InfAssetImage(
                account.socialNetWorkProvider.logoRawAssetMonochrome,
                width: 32.0,
                height: 32.0,
              ),
            ),
            verticalMargin8,
            const Text(
              'FOLLOWERS',
              style: const TextStyle(color: AppTheme.white50),
            ),
            verticalMargin8,
            Text(account.audienceSizeAsString()),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileSummary(
          user: user,
          heightTotalPercentage: 0.65,
        ),
        Container(
          color: AppTheme.listViewItemBackground,
          child: OverflowRow(
            itemPadding: const EdgeInsets.only(right: 4.0, left: 4.0),
            childrenWidth: 110,
            height: 120.0,
            children: rowItems,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ABOUT ${user.name.toUpperCase()}',
                textAlign: TextAlign.start,
                style: AppTheme.formFieldLabelStyle,
              ),
              verticalMargin8,
              Text(user.description),
              verticalMargin16,
              Container(
                height: 1,
                color: AppTheme.white12,
              ),
              verticalMargin16,
              const Text(
                'MIN FEE',
                textAlign: TextAlign.start,
                style: AppTheme.formFieldLabelStyle,
              ),
              verticalMargin8,
              Text(user.minimalFee > Money.zero ? '\$${user.minimalFee.toString()}' : ''),
              verticalMargin16,
              Container(
                height: 1,
                color: AppTheme.white12,
              ),
              verticalMargin32,
            ],
          ),
        ),
      ],
    );
  }
}
