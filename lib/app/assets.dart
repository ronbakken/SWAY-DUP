import 'package:inf/domain/domain.dart';

class AppFonts {
  const AppFonts();

  static const String mavenPro = 'MavenPro';
}

class AppLogo {
  const AppLogo();

  static const infSplash = AppAsset.bitmap('assets/images/splash_logo.png');
  static const infLogo = AppAsset.vector('assets/images/logo_inf.svg');
  static const infLogoWithShadow = AppAsset.vector('assets/images/logo_inf_shadow.svg');
  static const instagram = AppAsset.bitmap('assets/images/logo_instagram.png');
  static const facebook = AppAsset.vector('assets/images/logo_facebook.svg');
  static const google = AppAsset.vector('assets/images/logo_google.svg');
  static const twitter = AppAsset.vector('assets/images/logo_twitter.svg');
  static const email = AppAsset.vector('assets/images/logo_email.svg');

  static AppAsset getDeliverableChannel(DeliverableChannels channel) {
    switch (channel) {
      case DeliverableChannels.instagram:
        return instagram;
      case DeliverableChannels.facebook:
        return facebook;
      case DeliverableChannels.twitter:
        return twitter;
      // TODO add correct images for channels
      case DeliverableChannels.youtube:
      case DeliverableChannels.blog:
      case DeliverableChannels.custom:
        return twitter;
    }
    throw StateError('Bad Deliverable Channel');
  }
}

class AppIcons {
  const AppIcons();

  // Main Icons
  static const helpIcon = AppAsset.vector('assets/images/icon_help.svg');
  static const menuIcon = AppAsset.vector('assets/images/icon_menu.svg');
  static const offersIcon = AppAsset.vector('assets/images/icon_offers.svg');
  static const proposalIcon = AppAsset.vector('assets/images/icon_proposal.svg');
  static const agreementsIcon = AppAsset.vector('assets/images/icon_agreements.svg');
  static const locationIcon = AppAsset.vector('assets/images/icon_location.svg');
  static const rewardsIcon = AppAsset.vector('assets/images/icon_rewards.svg');
  static const descriptionIcon = AppAsset.vector('assets/images/icon_description.svg');

  static const browseIcon = AppAsset.vector('assets/images/icon_browse.svg');
  static const dealsIcon = AppAsset.vector('assets/images/icon_deals.svg');
  static const directOffersIcon = AppAsset.vector('assets/images/icon_direct.svg');
  static const historyIcon = AppAsset.vector('assets/images/icon_history.svg');
  static const switchUserIcon = AppAsset.vector('assets/images/icon_switch_user.svg');
}

class AppAsset {
  const AppAsset.bitmap(this.path) : this.type = AppAssetType.Bitmap;

  const AppAsset.vector(this.path) : this.type = AppAssetType.Vector;

  final String path;
  final AppAssetType type;
}

enum AppAssetType {
  Bitmap,
  Vector,
}
