import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/user_profile/profile_summery.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_switch.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf_api_client/inf_api_client.dart';

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
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ProfileSummery(
            user: user,
            showOnlyImage: true,
            heightImagePercentage: 1.0,
            gradientStop: 0.9,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StreamBuilder<List<SocialMediaAccountWrapper>>(
                    stream: backend.get<UserManager>().getSocialMediaAccounts(user),
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        var entries = <Widget>[];
                        for (var account in snapShot.data) {
                          var provider = backend
                              .get<ConfigService>()
                              .getSocialNetworkProviderById(account.socialMediaAccount.socialNetworkProviderId);
                          BoxDecoration logoDecoration;
                          if (provider.logoBackgroundData.isNotEmpty) {
                            logoDecoration = BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: MemoryImage(provider.logoBackgroundData),
                                fit: BoxFit.fill,
                              ),
                            );
                          } else {
                            logoDecoration = BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(provider.logoBackGroundColor),
                            );
                          }

                          entries.add(Row(
                            children: [
                              Container(
                                  width: 32,
                                  height: 32,
                                  decoration: logoDecoration,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InfMemoryImage(
                                      provider.logoMonochromeData,
                                      height: 20,
                                    ),
                                  )),
                              SizedBox(width: 16.0,),
                              Text(provider.name),
                              Spacer(),
                              InfSwitch(
                                value: account.socialMediaAccount.isActive,
                                activeColor: AppTheme.blue,
                              ),
                            ],
                          ));
                        }
                        return Column(mainAxisSize: MainAxisSize.min, children: entries);
                      } else {
                        return SizedBox();
                      }
                    }),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
