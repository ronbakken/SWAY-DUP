import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/user_profile/edit_social_media_view.dart';
import 'package:inf/ui/user_profile/profile_summery.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/location_selector_page.dart';
import 'package:inf/ui/widgets/routes.dart';

class EditProfilePage extends StatefulWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) => EditProfilePage(),
    );
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var user = backend.get<UserManager>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name.toUpperCase()),
        centerTitle: true,
        backgroundColor: AppTheme.blackTwo,
      ),
      backgroundColor: AppTheme.editPageBackground,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileSummery(
                    user: user,
                    showOnlyImage: true,
                    heightImagePercentage: 1.0,
                    gradientStop: 0.9,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("MANAGE YOUR SOCIAL ACCOUNTS",
                              textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          EditSocialMediaView(),
                          ColumnSeparator(),
                          Text("YOUR NAME", textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          TextFormField(
                            initialValue: user.name,
                          ),
                          SizedBox(height: 16),
                          Text("ABOUT YOU", textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          TextFormField(
                            initialValue: user.description,
                          ),
                          SizedBox(height: 16),
                          Text("MIN FEE", textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                            initialValue: '\$${user.minimalFee.toString()}',
                          ),
                          SizedBox(height: 16),
                          Text("Location", textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          InkWell(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 24, top: 8.0),
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              var location = await Navigator.of(context).push(LocationSelectorPage.route());
                              // TODO Location
                            },
                          ),
                          SizedBox(height: 16)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 8),
              child: InfStadiumButton(
                height: 56,
                color: Colors.white,
                text: 'Update',
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
