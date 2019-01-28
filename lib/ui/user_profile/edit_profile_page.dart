import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/ui/user_profile/edit_social_media_view.dart';
import 'package:inf/ui/user_profile/profile_summary.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/image_source_selector_dialog.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_loader.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/location_selector_page.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:rx_command/rx_command.dart';

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
  RxCommandListener<UserUpdateData, void> userUpdateListener;

  @override
  void initState() {
    userUpdateListener = RxCommandListener(backend.get<UserManager>().updateUserCommand,
        onIsBusy: () => InfLoader.show(context),
        onNotBusy: () => InfLoader.hide(),
        onError: (error) async {
          print(error);
          await showMessageDialog(
              context, 'Update Problem', 'Sorry we had a problem update your user. Please try again later');
        });
    super.initState();
  }

  @override
  void dispose() {
    userUpdateListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        initialData: backend.get<UserManager>().currentUser,
        stream: backend.get<UserManager>().currentUserUpdates,
        builder: (context, snapshot) {
          var user = snapshot.data;
          return Scaffold(
              resizeToAvoidBottomPadding: true,
              appBar: AppBar(
                title: Text(user.name.toUpperCase()),
                centerTitle: true,
                backgroundColor: AppTheme.blackTwo,
              ),
              backgroundColor: AppTheme.editPageBackground,
              body: UserDataView(
                user: user,
              ));
        });
  }
}

class UserDataView extends StatefulWidget {
  final User user;

  const UserDataView({Key key, this.user}) : super(key: key);
  @override
  _UserDataViewState createState() => _UserDataViewState();
}

class _UserDataViewState extends State<UserDataView> {
  GlobalKey formKey = GlobalKey();
  GlobalKey socialMediaKey = GlobalKey();

  File selectedImageFile;
  String name;
  String aboutYou;
  int minFee;
  Location location;
  User user;

  bool hasChanged = false;

  @override
  void initState() {
    user = widget.user;
    location = user.location;
    super.initState();
  }

  @override
  void didUpdateWidget(UserDataView oldWidget) {
    if (widget.user != oldWidget.user) {
      user = widget.user;
      location = user.location;
      selectedImageFile = null;
      hasChanged = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (hasChanged) {
          var shouldPop = await showQueryDialog(context, 'Be careful', 'Your changes will be lost if you don\'t tap on update.'
          '\nDo you really want to leave this page?');
          return shouldPop;
        }
        return true;
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: <Widget>[
                      ProfileSummary(
                        user: user,
                        showOnlyImage: true,
                        heightImagePercentage: 1.0,
                        gradientStop: 0.9,
                        imageFile: selectedImageFile,
                      ),
                      Positioned(
                        right: 16,
                        top: 32,
                        child: InkResponse(
                          onTap: onEditImage,
                          child: InfAssetImage(
                            AppIcons.edit,
                            width: 32,
                          ),
                        ),
                      )
                    ],
                  ),
                  Form(
                    onChanged: () => setState(() => hasChanged = true),
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("YOUR NAME", textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          TextFormField(
                            initialValue: user.name,
                            validator: (s) => s.isEmpty ? 'You have to provide a Name' : null,
                            onSaved: (s) => name = s,
                          ),
                          SizedBox(height: 16),
                          Text("MANAGE YOUR SOCIAL ACCOUNTS",
                              textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          EditSocialMediaView(
                            key: socialMediaKey,
                            socialMediaAccounts: user.socialMediaAccounts,
                            onChanged: () => setState(() => hasChanged = true),
                          ),
                          ColumnSeparator(),
                          Text("ABOUT YOU", textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          TextFormField(
                            initialValue: user.description,
                            validator: (s) => s.isEmpty ? 'You have to provide a Name' : null,
                            onSaved: (s) => aboutYou = s,
                          ),
                          SizedBox(height: 16),
                          Text("MIN FEE", textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          TextFormField(
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                            initialValue: user.minimalFee != null ? '\$${user.minimalFee.toString()}' : null,
                            onSaved: (s) => minFee = int.tryParse(s),
                          ),
                          SizedBox(height: 16),
                          Text("Location", textAlign: TextAlign.left, style: AppTheme.textStyleformfieldLabel),
                          SizedBox(height: 8),
                          InkWell(
                            child: Row(
                              children: [
                                Expanded(child: Text(location.name ?? '')),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 24, top: 8.0),
                                    child: Icon(Icons.search),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              var result = await Navigator.of(context).push(LocationSelectorPage.route());
                              if (result != null) {
                                setState(() {
                                  hasChanged = true;
                                  location = result;
                                });
                              }
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
                onPressed: hasChanged ? onUpdate : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onEditImage() async {
    var camera = await showDialog<bool>(context: context, builder: (context) => ImageSourceSelectorDialog());
    // user aborted the dialog
    if (camera == null) {
      return;
    }
    selectedImageFile =
        camera ? await backend.get<ImageService>().takePicture() : await backend.get<ImageService>().pickImage();
    if (selectedImageFile != null) {
      setState(() {});
    }
  }

  void onUpdate() async {
    FormState formState = formKey.currentState;
    if (formState.validate()) {
      EditSocialMediaViewState socialMediaEditState = socialMediaKey.currentState;
      var socialAccounts = socialMediaEditState.getConnectedAccounts();
      assert(socialAccounts != null);

      if (socialAccounts.isEmpty) {
        await showMessageDialog(context, 'Missing Data', 'You need minimal one connected social media account');
        return;
      }

      formState.save();
      var userData = UserUpdateData(
          user: user.copyWith(
            name: name,
            description: aboutYou,
            location: location,
            minimalFee: minFee ?? 0,
            socialMediaAccounts: socialAccounts,
          ),
          profilePicture: selectedImageFile);
      backend.get<UserManager>().updateUserCommand(userData);
      setState(()=>hasChanged = false);
    }
  }
}
