import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/user_profile/edit_profile_page.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/inf_loader.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';

class NewUserProfilePage extends StatefulWidget {
  final UserType userType;

  const NewUserProfilePage({Key key, this.userType}) : super(key: key);

  static Route<dynamic> route(UserType userType) {
    return FadePageRoute(
      builder: (BuildContext context) => NewUserProfilePage(userType: userType),
    );
  }

  @override
  _NewUserProfilePageState createState() => _NewUserProfilePageState();
}

class _NewUserProfilePageState extends State<NewUserProfilePage> {
  RxCommandListener<UserUpdateData, void> userUpdateListener;

  @override
  void initState() {
    userUpdateListener = RxCommandListener(
      backend.get<UserManager>().updateUserCommand,
      onValue: (_) {
        Navigator.of(context).pushAndRemoveUntil(MainPage.route(), (_) => false);
      },
      onIsBusy: () => InfLoader.show(context),
      onNotBusy: () => InfLoader.hide(),
      onError: (error) async {
        print(error);
        await showMessageDialog(
            context, 'Setup Problem', 'Sorry we had a problem creating your user. Please try again later');
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    userUpdateListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('ACCOUNT SETUP'),
        centerTitle: true,
        backgroundColor: AppTheme.blackTwo,
      ),
      backgroundColor: AppTheme.listViewAndMenuBackground,
      body: UserDataView(
        user: User(
          userType: widget.userType,
          accountState: AccountState.waitingForActivation,
          name: '',
          description: '',
          socialMediaAccounts: [],
          categories: [],
        ),
      ),
    );
  }
}
