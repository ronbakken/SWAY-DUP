import 'dart:typed_data';

class AppFonts {
  const AppFonts();

  static const String mavenPro = 'MavenPro';
}

class AppLogo {
  const AppLogo();

  static const infSplash = AppAsset.bitmap('assets/images/splash_logo.png');
  static const infLogo = AppAsset.vector('assets/images/logo_inf.svg');
  static const infLogoWithShadow = AppAsset.vector('assets/images/logo_inf_shadow.svg');
  static const swayLogo = AppAsset.vector('assets/images/logo_sway.svg');
  static const instagram = AppAsset.bitmap('assets/images/logo_instagram.png');
  static const facebook = AppAsset.vector('assets/images/logo_facebook.svg');
  static const google = AppAsset.vector('assets/images/logo_google.svg');
  static const twitter = AppAsset.vector('assets/images/logo_twitter.svg');
  static const email = AppAsset.vector('assets/images/logo_email.svg');
}

class AppIcons {
  const AppIcons();

  // Main Icons
  static const help = AppAsset.vector('assets/images/icon_help.svg');
  static const menu = AppAsset.vector('assets/images/icon_menu.svg');
  static const offers = AppAsset.vector('assets/images/icon_offers.svg');
  static const proposal = AppAsset.vector('assets/images/icon_proposal.svg');
  static const agreements = AppAsset.vector('assets/images/icon_agreements.svg');
  static const location = AppAsset.vector('assets/images/icon_location.svg');
  static const gift = AppAsset.vector('assets/images/icon_gift.svg');
  static const description = AppAsset.vector('assets/images/icon_description.svg');
  static const category = AppAsset.vector('assets/images/icon_category.svg');
  static const deliverable = AppAsset.vector('assets/images/icon_deliverable.svg');
  static const locked = AppAsset.vector('assets/images/icon_locked.svg');
  static const dollarSign = AppAsset.vector('assets/images/icon_dollar_sign.svg');
  static const mapMarker = AppAsset.vector('assets/images/icon_map_marker.svg');
  static const mapMarkerBusiness = AppAsset.vector('assets/images/icon_map_marker_business.svg');
  static const mapMarkerDirectOffer = AppAsset.vector('assets/images/icon_map_marker_direct_offer.svg');
  static const message = AppAsset.vector('assets/images/icon_message.svg');
  static const inbox = AppAsset.vector('assets/images/icon_inbox.svg');
  static const search = AppAsset.vector('assets/images/icon_search.svg');
  static const earnings = AppAsset.vector('assets/images/icon_earnings.svg');
  static const edit = AppAsset.vector('assets/images/icon_edit.svg');
  static const value = AppAsset.vector('assets/images/icon_value.svg');
  static const browse = AppAsset.vector('assets/images/icon_browse.svg');
  static const deals = AppAsset.vector('assets/images/icon_deals.svg');
  static const directOffers = AppAsset.vector('assets/images/icon_direct.svg');
  static const history = AppAsset.vector('assets/images/icon_history.svg');
  static const switchUser = AppAsset.vector('assets/images/icon_switch_user.svg');
  static const camera = AppAsset.vector('assets/images/icon_camera.svg');
  static const photo = AppAsset.vector('assets/images/icon_photo.svg');
  static const connect = AppAsset.vector('assets/images/icon_connect.svg');
  static const check = AppAsset.vector('assets/images/icon_check.svg');
  static const thumbUp = AppAsset.vector('assets/images/icon_thumb_up.svg');
  static const arrowDown = AppAsset.vector('assets/images/icon_arrow_down.svg');
  static const tick = AppAsset.vector('assets/images/icon_tick.svg');
  static const close = AppAsset.vector('assets/images/icon_close.svg');
  static const add = AppAsset.vector('assets/images/icon_add.svg');
}

class AppImages {
  const AppImages();

  static const mapPlaceHolder = AppAsset.bitmap('assets/images/map_placeholder_tile.png');

  static const onBoarding1 = AppAsset.bitmap('assets/images/img_onboarding1.jpg');
  static const onBoarding2 = AppAsset.bitmap('assets/images/img_onboarding2.jpg');
  static const onBoarding3 = AppAsset.bitmap('assets/images/img_onboarding3.jpg');

  static const handshake = AppAsset.bitmap('assets/images/img_handshake.png');
}

class AppAsset {
  const AppAsset.bitmap(
    this.path, {
    this.matchTextDirection = false,
  })  : this.data = null,
        this.type = AppAssetType.Bitmap;

  const AppAsset.vector(
    this.path, {
    this.matchTextDirection = false,
  })  : this.data = null,
        this.type = AppAssetType.Vector;

  const AppAsset.raw(
    this.data, {
    this.matchTextDirection = false,
  })  : this.path = null,
        this.type = AppAssetType.Raw;

  final String path;
  final Uint8List data;
  final AppAssetType type;
  final bool matchTextDirection;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAsset &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          type == other.type &&
          matchTextDirection == other.matchTextDirection;

  @override
  int get hashCode => path.hashCode ^ type.hashCode ^ matchTextDirection.hashCode;

  @override
  String toString() => 'AppAsset{$type:$path}';
}

enum AppAssetType {
  Bitmap,
  Vector,
  Raw,
}
