import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

import 'inf_divider.dart';

class InfLockPanel extends StatelessWidget {
  const InfLockPanel({
    Key key,
    this.onSignUpPressed,
    this.onLoginPressed,
  }) : super(key: key);

  final VoidCallback onSignUpPressed;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// We add the title of the Reward group here to have a better teaser
        const InfDivider(),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: const [
              CircleAvatar(
                backgroundColor: const Color(0x33000000),
                radius: 15.0,
                child: InfAssetImage(AppIcons.gift, height: 14.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'REWARD',
                  style: const TextStyle(
                    color: Colors.white54,
                    height: 0.95,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Here starts the lock shield
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Material(
            elevation: 3.0,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(6.0),
            color: AppTheme.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CurvedBox(
                  bottom: true,
                  color: AppTheme.blue,
                  curveFactor: 0.8,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.lock, size: 36.0),
                        verticalMargin8,
                        Text('THERE IS MUCH MORE TO SEE'),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 13.0),
                  child: Text(
                    'To view the full offer and apply you need to be a member of INF.',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 13.0),
                  child: Text(
                    "It's free to sign up and takes only a few seconds",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 26.0),
                  child: RaisedButton(
                    onPressed: onSignUpPressed,
                    shape: const StadiumBorder(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 44.0,
                      child: const Text(
                        'SIGNUP TO SEE ALL',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 26, right: 26.0, bottom: 20.0),
                    child: InkWell(
                      onTap: onLoginPressed,
                      child: const Text(
                        'ALREADY A MEMBER? LOGIN',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
