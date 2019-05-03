import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class SwitchUserDialog extends StatelessWidget {
  final List<LoginProfile> profiles;

  const SwitchUserDialog({Key key, this.profiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Material(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const CurvedBox(
            bottom: true,
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
              child: Center(child: const Text('Switch to...')),
            ),
          ),
          verticalMargin16,
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: profiles.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < profiles.length) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: AppTheme.listViewItemBackground,
                    height: 48,
                    child: FlatButton(
                      onPressed: () => Navigator.of(context).pop<LoginProfile>(profiles[index]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WhiteBorderCircle(
                            radius: 20,
                            child: Image.network(profiles[index].avatarUrl),
                          ),
                          Text(
                            profiles[index].userName,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return InfStadiumButton(
                    text: 'Log out to create a new profile',
                    onPressed: () => Navigator.of(context).pop<LoginProfile>(
                          LoginProfile(email: 'LOGOUT'),
                        ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: InfStadiumButton(
              text: 'CANCEL',
              height: 56.0,
              color: AppTheme.blue,
              onPressed: () => Navigator.of(context).pop<LoginProfile>(null),
            ),
          )
        ]),
      ),
    );
  }
}
