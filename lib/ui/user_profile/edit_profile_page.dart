import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/money.dart';
import 'package:inf/ui/user_profile/edit_social_media_view.dart';
import 'package:inf/ui/user_profile/profile_summary.dart';
import 'package:inf/ui/widgets/asset_imageI_circle_background.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/image_source_selector_dialog.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_input_decorator.dart';
import 'package:inf/ui/widgets/inf_loader.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/location_selector_page.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf_api_client/inf_api_client.dart';
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
    userUpdateListener = RxCommandListener(
      backend<UserManager>().updateUserCommand,
      onIsBusy: () => InfLoader.show(context),
      onNotBusy: () => InfLoader.hide(),
      onError: (error) async {
        print(error);
        await showMessageDialog(
            context, 'Update Problem', 'Sorry we had a problem update your user. Please try again later');
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
    return StreamBuilder<User>(
      initialData: backend<UserManager>().currentUser,
      stream: backend<UserManager>().currentUserUpdates,
      builder: (context, snapshot) {
        var user = snapshot.data;
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(user.name.toUpperCase()),
            centerTitle: true,
            backgroundColor: AppTheme.blackTwo,
          ),
          backgroundColor: AppTheme.listViewAndMenuBackground,
          body: UserDataView(
            user: user,
          ),
        );
      },
    );
  }
}

/// This [UserDataView] is used for editing existing profiles as well as for seting up new users
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
  bool newUser;

  @override
  void initState() {
    user = widget.user;
    newUser = user.accountState == UserDto_Status.waitingForActivation;
    location = user.location;
    super.initState();
  }

  @override
  void didUpdateWidget(UserDataView oldWidget) {
    if (!newUser) {
      if (widget.user != oldWidget.user) {
        user = widget.user;
        location = user.location;
        selectedImageFile = null;
        hasChanged = false;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnItems = <Widget>[
      InfTextFormField(
        decoration: const InputDecoration(
          labelText: 'YOUR NAME',
        ),
        initialValue: user.name,
        validator: (s) => s.isEmpty ? 'You have to provide a Name' : null,
        onSaved: (s) => name = s,
      ),
      verticalMargin16,
      InfTextFormField(
        decoration: const InputDecoration(
          labelText: 'ABOUT YOU',
        ),
        initialValue: user.description,
        validator: (s) => s.isEmpty ? 'You have some information about you' : null,
        onSaved: (s) => aboutYou = s,
      ),
      verticalMargin16,
    ];

    if (user.userType == UserType.influencer) {
      columnItems.addAll([
        Text("${newUser ? 'CONNECT' : 'MANAGE'} YOUR SOCIAL ACCOUNTS",
            textAlign: TextAlign.left, style: AppTheme.formFieldLabelStyle),
        verticalMargin8,
        EditSocialMediaView(
          key: socialMediaKey,
          socialMediaAccounts: user.socialMediaAccounts,
          onChanged: () => setState(() => hasChanged = true),
        ),
        const ColumnSeparator(),
        InfTextFormField(
          decoration: const InputDecoration(labelText: 'MIN FEE (optional)', icon: Text('\$')),
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          initialValue: user.minimalFee != null ? user.minimalFee.toString() : null,
          onSaved: (s) => minFee = int.tryParse(s),
        ),
        verticalMargin16,
      ]);
    }

    columnItems.addAll([
      InkWell(
        child: InfInputDecorator(
          decoration: const InputDecoration(labelText: 'LOCATION'),
          child: Row(
            children: [
              Expanded(child: Text(location?.name ?? '')),
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, top: 8.0),
                  child: InfIcon(AppIcons.search),
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
      ),
      verticalMargin16,
    ]);

    return WillPopScope(
      onWillPop: () async {
        // if we are filling out a new users profile there is no back
        if (newUser) {
          return false;
        }
        if (hasChanged) {
          var shouldPop = await showQueryDialog(
            context,
            'Be careful',
            'Your changes will be lost if you don\'t tap on update.\n'
                'Do you really want to leave this page?',
          );
          return shouldPop;
        }
        return true;
      },
      // FIXME: currently we can scroll when keyboard appears with a large content gap at bottom
      child: InfPageScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                newUser && selectedImageFile == null
                    ? _ProfilePicturePlaceHolder(
                        onCameraTap: () => onSelectImage(true),
                        onLibraryTap: () => onSelectImage(false),
                      )
                    : ProfileSummary(
                        user: user,
                        showOnlyImage: true,
                        heightImagePercentage: 1.0,
                        gradientStop: 0.9,
                        imageFile: selectedImageFile,
                      ),
                // Only show edit button if there is already an image
                !newUser || selectedImageFile != null
                    ? Positioned(
                        right: 16,
                        top: 32,
                        child: InkResponse(
                          onTap: onEditImage,
                          child: const InfIcon(AppIcons.edit, size: 32),
                        ),
                      )
                    : emptyWidget,
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
                  children: columnItems,
                ),
              ),
            )
          ],
        ),
        bottom: InfBottomButton(
          text: newUser ? 'CREATE ACCOUNT' : 'UPDATE',
          onPressed: hasChanged ? onButtonPressed : null,
          panelColor: AppTheme.listViewAndMenuBackground,
        ),
      ),
    );
  }

  void onEditImage() async {
    var camera = await showDialog<bool>(context: context, builder: (context) => ImageSourceSelectorDialog());
    // user aborted the dialog
    if (camera == null) {
      return;
    }
    onSelectImage(camera);
  }

  void onSelectImage(bool camera) async {
    selectedImageFile =
        camera ? await backend<ImageService>().takePicture() : await backend<ImageService>().pickImage();
    if (selectedImageFile != null) {
      setState(() {
        hasChanged = true;
      });
    }
  }

  void onButtonPressed() async {
    FormState formState = formKey.currentState;
    if (formState.validate()) {
      EditSocialMediaViewState socialMediaEditState = socialMediaKey.currentState;
      List<SocialMediaAccount> socialAccounts;

      if (user.userType == UserType.influencer) {
        socialAccounts = socialMediaEditState.getConnectedAccounts();
        assert(socialAccounts != null);

        if (socialAccounts.isEmpty) {
          await showMessageDialog(
              context, 'We need a bit more...', 'You need minimal one connected social media account');
          return;
        }
      }

      if (newUser && selectedImageFile == null) {
        await showMessageDialog(context, 'We need a bit more...', 'You have to select a profile picture so sign-up');
        return;
      }

      if (newUser && location == null) {
        await showMessageDialog(context, 'We need a bit more...', 'You have to select a location to sign-up');
        return;
      }

      formState.save();
      var userData = UserUpdateData(
        user: user.copyWith(
          name: name,
          description: aboutYou,
          location: location,
          minimalFee: Money.fromInt(minFee ?? 0),
          socialMediaAccounts: socialAccounts ?? [],
        ),
        profilePicture: selectedImageFile,
      );
      backend<UserManager>().updateUserCommand(userData);
    } else {
      await showMessageDialog(context, 'We need a bit more...', 'Please fill out all fields');
    }
  }
}

class _ProfilePicturePlaceHolder extends StatelessWidget {
  final VoidCallback onLibraryTap;
  final VoidCallback onCameraTap;

  const _ProfilePicturePlaceHolder({Key key, this.onLibraryTap, this.onCameraTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      color: AppTheme.listViewItemBackground,
      height: mediaQuery.size.height * 0.48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AssetImageCircleBackgroundButton(
            radius: 30,
            backgroundColor: AppTheme.grey,
            asset: AppIcons.photo,
            onTap: onLibraryTap,
          ),
          AssetImageCircleBackgroundButton(
            radius: 30,
            backgroundColor: AppTheme.grey,
            asset: AppIcons.camera,
            onTap: onCameraTap,
          ),
        ],
      ),
    );
  }
}
