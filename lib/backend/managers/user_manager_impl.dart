import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class UserManagerImplementation implements UserManager {
  @override
  bool isLoggedIn = true;

  @override
  User get currentUser => backend.get<AuthenticationService>().currentUser;

  @override
  RxCommand<void, bool> logInUserCommand;
  // RxCommand<User, void> createUserByEmailCommand;

  @override
  RxCommand<SocialMediaAccount, void> updateSocialMediaAccountCommand;

  @override
  RxCommand<void, void> updateSocialMediaDataCommand;

  @override
  RxCommand<User, void> updateUserCommand;

  UserManagerImplementation() {
    var authenticationService = backend.get<AuthenticationService>();

    logInUserCommand = RxCommand.createAsyncNoParam(authenticationService.loginUserWithToken);

    updateSocialMediaAccountCommand = RxCommand.createAsyncNoResult<SocialMediaAccount>(
        (account) => authenticationService.updateSocialMediaAccount(account));

    updateUserCommand = RxCommand.createAsyncNoResult<User>((user) => authenticationService.updateUser(user));

    updateSocialMediaDataCommand =
        RxCommand.createAsyncNoParamNoResult(authenticationService.updateSocialMediaAccounts);
  }

  @override
  Observable<User> get currentUserUpdates => backend.get<AuthenticationService>().currentUserUpdates;

  @override
  Observable<List<SocialMediaAccountWrapper>> get currentSocialMediaAccountsUpdates {
    return backend
        .get<AuthenticationService>()
        .currentUserSocialMediaUpdates
        .map<List<SocialMediaAccountWrapper>>((socialMediaAccounts) {
      return socialMediaAccounts.map<SocialMediaAccountWrapper>((account) {
        var provider = backend
            .get<ConfigService>()
            .socialNetworkProviders
            .firstWhere((s) => s.id == account.socialNetworkProviderId);
        assert(provider != null);
        return SocialMediaAccountWrapper(
          monoChromeIcon: Uint8List.fromList(provider.logoMonochromeData),
          socialMediaAccount: account,
        );
      }).toList();
    });
  }
}
