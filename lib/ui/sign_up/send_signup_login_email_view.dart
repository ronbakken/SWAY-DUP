import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_loader.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';

class SendSignupLoginEmailView extends StatefulWidget {
  final bool newUser;
  final UserType userType;

  const SendSignupLoginEmailView({Key key, this.newUser, this.userType}) : super(key: key);
  @override
  _SendSignupLoginEmailViewState createState() => _SendSignupLoginEmailViewState();
}

enum _steps { queryEmail, confirmEmail, emailSent }

class _SendSignupLoginEmailViewState extends State<SendSignupLoginEmailView> {
  _steps currentStep = _steps.queryEmail;
  String _emailAddress = '';
  String _invitationCode;
  List<Widget> columnItems;

  RxCommandListener sendLoginListener;

  @override
  void initState() {
    sendLoginListener = RxCommandListener(backend.get<UserManager>().sendLoginEmailCommand,
        onValue: (_) {
          setState(() {
            currentStep = _steps.emailSent;
          });
        },
        onIsBusy: () => InfLoader.show(context),
        onNotBusy: () => InfLoader.hide(),
        onError: (error) async {
          print(error);
          String message;
          String title = 'Sending problem';
          if (error is InvalidInvitationCodeException) {
            title = 'Invalid Invitation code';
            InvalidInvitationCodeException ex = error;
            switch (ex.status) {
              case GetInvitationCodeStatusResponse_InvitationCodeStatus.EXPIRED:
                message = 'The invitation code you entered has has expired. Please try another one';
                break;
              case GetInvitationCodeStatusResponse_InvitationCodeStatus.USED:
                message = 'The invitation code you entered has already been used. Please try another one';
                break;
              default:
                message = 'The invitation code you entered is invalid. Please try another one';
            }
          } else {
            message = 'Sorry we encountered a problem while sending you email. Please try again later';
          }

          await showMessageDialog(context, title, message);
        });
    super.initState();
  }

  @override
  void dispose() {
    sendLoginListener?.dispose();
    super.dispose();
  }

  bool _testSubmitEnabled() => (widget.newUser && _invitationCode != null && _invitationCode.isNotEmpty &&
                  _emailAddress.isNotEmpty) || (!widget.newUser && _emailAddress.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case _steps.queryEmail:
        String _text;
        if (widget.newUser) {
          _text = 'Please enter your email adress and your invitation code so that we can get you on board';
        } else {
          _text = 'Welcome back!\nPlease enter your email adress so that we can send you a login link';
        }
        columnItems = <Widget>[
          Text(_text),
          SizedBox(height: 32),
          Text(
            'YOUR EMAIL ADDRESS',
            textAlign: TextAlign.left,
            style: AppTheme.textStyleformfieldLabel,
          ),
          SizedBox(height: 8),
          TextField(
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.emailAddress,
            onChanged: (s) => setState(()=> _emailAddress = s),
            onSubmitted: (s) => _testSubmitEnabled() ? onButtonPressed() : null,
          ),
          widget.newUser
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'YOUR INVITATION CODE',
                      style: AppTheme.textStyleformfieldLabel,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      onChanged: (s) => setState(()=> _invitationCode = s),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(height: 32),
          InfStadiumButton(
            text: 'SUBMIT',
            onPressed: _testSubmitEnabled() ? onButtonPressed : null,
          )
        ];
        break;
      case _steps.confirmEmail:
        TextSpan _text = TextSpan(text: 'We are about to send you a ', children: []);
        if (widget.newUser) {
          _text.children.add(TextSpan(text: 'sign-up email to \n'));
        } else {
          _text.children.add(TextSpan(text: 'login email to \n'));
        }
        _text.children.add(TextSpan(text: _emailAddress, style: const TextStyle(fontWeight: FontWeight.bold)));
        columnItems = <Widget>[
          Text.rich(
            _text,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Text('Made a mistake?', textAlign: TextAlign.center),
          SizedBox(height: 8),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Let\'s try this again',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
            ),
            onTap: () => setState(() => currentStep = _steps.queryEmail),
          ),
          SizedBox(height: 32),
          InfStadiumButton(
            text: 'YES, THAT\'S THE CORRECT EMAIL',
            onPressed: onButtonPressed,
          )
        ];
        break;
      case _steps.emailSent:
        columnItems = <Widget>[
          SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(24),
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.blue,
            ),
            child: InfAssetImage(AppIcons.check),
          ),
          SizedBox(height: 16),
          Text('Your ${widget.newUser ? 'sign-up' : 'login'} link has been\nsent successfully.',
              textAlign: TextAlign.center),
          SizedBox(height: 32),
          InfStadiumButton(
            text: 'OPEN EMAIL NOW',
            onPressed: onButtonPressed,
          )
        ];
        break;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: columnItems,
      ),
    );
  }

  Future<void> onButtonPressed() async {
    switch (currentStep) {
      case _steps.queryEmail:
        setState(() {
          currentStep = _steps.confirmEmail;
        });
        break;
      case _steps.confirmEmail:
        backend.get<UserManager>().sendLoginEmailCommand(
              LoginEmailInfo(
                email: _emailAddress,
                invitationCode: _invitationCode,
                userType: widget.userType,
              ),
            );
        break;
      case _steps.emailSent:
        break;
    }
  }
}
