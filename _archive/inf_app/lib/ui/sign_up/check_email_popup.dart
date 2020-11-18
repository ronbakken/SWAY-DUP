import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf_api_client/inf_api_client.dart';

class CheckEmailPopUp extends StatelessWidget {
  final UserType userType;
  final String email;

  const CheckEmailPopUp({Key key, this.userType, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String headline2;
    switch (userType) {
      case UserType.influencer:
        headline2 = 'INFLUENCER ACCOUNT';
        break;
      case UserType.business:
        headline2 = 'BUSINESS ACCOUNT';
        break;
      default:
        headline2 = '';
        assert(false, 'Never should get here');
    }
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            verticalMargin36,
            const Text('CREATE AN'),
            verticalMargin8,
            Text(headline2),
            verticalMargin8,
            const Text('Thanks!'),
            verticalMargin36,
            const Text('We send a verification mail to'),
            Text('$email, please follow'),
            const Text('the instructions in the mail.'),
            verticalMargin36,
          ],
        ),
      ),
    );
  }
}
