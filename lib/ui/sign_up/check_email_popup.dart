import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_button.dart';

class CheckEmailPopUp extends StatelessWidget {
  final UserType userType;
  final String email;

  const CheckEmailPopUp({Key key, this.userType, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String headline2;
    switch (userType) {
      case UserType.influcencer:
        headline2 = 'INFLUENCER ACCOUNT';
        break;
      case UserType.business:
        headline2 = 'BUSINESS ACCOUNT';
        break;
      default:
        headline2 ='';
        assert(false,'Never should get here');
    }
    return Material(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
            color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40.0,),
            Text('CREATE AN'),
            SizedBox(height: 10.0,),
            Text(headline2),
            SizedBox(height: 10.0,),
            Text('Thanks!'),
            SizedBox(height: 40.0,),
            Text('We send a verification mail to'),
            Text('$email, please follow'),
            Text('the instructions in the mail.'),
            SizedBox(height: 40.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: InfButton(text: 'OPEN EMAIL',onPressed: () => Navigator.of(context).pop(),),
            )

          ],
        ),
      ),
    );
  }
}
