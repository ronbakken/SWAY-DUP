import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/routes.dart';

class SignUpPage extends StatelessWidget {

  final UserType userType;

  const SignUpPage({Key key, this.userType}) : super(key: key);

	static Route<dynamic> route({UserType userType}) {
		return FadePageRoute(
			builder: (context) =>
				SignUpPage(userType: userType,
				),
		);
	}

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('SignUp'),
      
    );
  }
}