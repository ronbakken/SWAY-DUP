import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/user_profile/profile_summary.dart';

class ProfileBusinessView extends StatelessWidget {
  final User user;

  const ProfileBusinessView({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileSummary(
          user: user,
          heightTotalPercentage: 0.65,
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
                height: 32.0,
              ),
            ],
          ),
        ),
      ],
    );  }
}
