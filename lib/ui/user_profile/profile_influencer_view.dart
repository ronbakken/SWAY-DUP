import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/user_profile/profile_summery.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/overflow_row.dart';

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
            InfMemoryImage(
              account.socialNetWorkProvider.logoMonochromeData,
              height: 32.0,
            ),
            SizedBox(height: 8),
            Text(
              'FOLLOWERS',
              style: const TextStyle(color: AppTheme.white50),
            ),
            SizedBox(height: 8),
            Text(followerCountAsString(account.audienceSize)),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileSummery(
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
                style: AppTheme.textStyleformfieldLabel,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(user.description),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 1,
                color: AppTheme.white12,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'MIN FEE',
                textAlign: TextAlign.start,
                style: AppTheme.textStyleformfieldLabel,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text('\$${user.minimalFee.toString()}'),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 1,
                color: AppTheme.white12,
              ),
              SizedBox(
                height: 32.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String followerCountAsString(int count) {
    if (count < 1100) {
      return count.toString();
    }
    if (count < 1100000) {
      double doubleCount = count / 1000;
      return '${doubleCount.toStringAsFixed(1)}k';
    } else {
      double doubleCount = count / 1000000;
      return '${doubleCount.toStringAsFixed(1)}m';
    }
  }
}
