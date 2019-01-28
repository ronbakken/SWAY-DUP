import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/user_profile/profile_summary.dart';

class ProfileBusinessView extends StatelessWidget {
  final User user;

  const ProfileBusinessView({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ProfileSummary(
        user: user,
      ),
    ]);
  }
}
