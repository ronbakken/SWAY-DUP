import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/routes.dart';

class ActivationSuccessPage extends StatelessWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) => ActivationSuccessPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x40000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfAssetImage(
              AppIcons.thumbUp,
              width: 72,
              height: 72,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Successfully Activated!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
                'Welcome to INF, within a few steps you will\n'
                'be all set up and ready to get networking',
                style: const TextStyle(fontSize: 18),),
            SizedBox(
              height: 32.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: InfStadiumButton(
                height: 56,
                text: 'LET\'S GET STARTED',
                color: AppTheme.blue,
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
