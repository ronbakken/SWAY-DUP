import 'package:inf/domain/domain.dart';

class AppFonts {
  const AppFonts();

  static const String mavenPro = 'MavenPro';
}

class AppLogo {
  const AppLogo();

  static const infSplash = AppAsset.bitmap('assets/images/splash_logo.png');
  static const infLogo = AppAsset.vector('assets/images/logo_inf.svg');
  static const infLogoWithShadow =
      AppAsset.vector('assets/images/logo_inf_shadow.svg');
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
  static const help = AppAsset.vector('assets/images/icon_help.svg');
  static const menu = AppAsset.vector('assets/images/icon_menu.svg');
  static const offers = AppAsset.vector('assets/images/icon_offers.svg');
  static const proposal = AppAsset.vector('assets/images/icon_proposal.svg');
  static const agreements =
      AppAsset.vector('assets/images/icon_agreements.svg');
  static const location = AppAsset.vector('assets/images/icon_location.svg');
  static const gift = AppAsset.vector('assets/images/icon_gift.svg');
  static const description =
      AppAsset.vector('assets/images/icon_description.svg');
  static const category = AppAsset.vector('assets/images/icon_category.svg');
  static const deliverable =
      AppAsset.vector('assets/images/icon_deliverables.svg');
  static const locked = AppAsset.vector('assets/images/icon_locked.svg');
  static const dollarSign =
      AppAsset.vector('assets/images/icon_dollar_sign.svg');
  static const mapMarker = AppAsset.vector('assets/images/icon_map_marker.svg');
  static const mapMarkerBusiness =
      AppAsset.vector('assets/images/icon_map_marker_business.svg');
  static const mapMarkerDirectOffer =
      AppAsset.vector('assets/images/icon_map_marker_direct_offer.svg');
  static const inbox = AppAsset.vector('assets/images/icon_inbox.svg');
  static const search = AppAsset.vector('assets/images/icon_search.svg');
  static const earnings = AppAsset.vector('assets/images/icon_earnings.svg');
  static const edit = AppAsset.vector('assets/images/icon_edit.svg');
  static const payments = AppAsset.vector('assets/images/icon_payments.svg');

  static const browse = AppAsset.vector('assets/images/icon_browse.svg');
  static const deals = AppAsset.vector('assets/images/icon_deals.svg');
  static const directOffers = AppAsset.vector('assets/images/icon_direct.svg');
  static const history = AppAsset.vector('assets/images/icon_history.svg');
  static const switchUser =
      AppAsset.vector('assets/images/icon_switch_user.svg');
}

class AppImages {
  const AppImages();

  static const mapPlaceHolder =
      AppAsset.bitmap('assets/images/map_placeholder_tile.png');
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
