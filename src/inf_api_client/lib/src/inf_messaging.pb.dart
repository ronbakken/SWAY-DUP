///
//  Generated code. Do not modify.
//  source: inf_messaging.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class NotifyRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NotifyRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'token')
    ..aOS(2, 'registrationToken')
    ..aOS(3, 'title')
    ..aOS(4, 'body')
    ..hasRequiredFields = false
  ;

  NotifyRequest() : super();
  NotifyRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NotifyRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NotifyRequest clone() => new NotifyRequest()..mergeFromMessage(this);
  NotifyRequest copyWith(void Function(NotifyRequest) updates) => super.copyWith((message) => updates(message as NotifyRequest));
  $pb.BuilderInfo get info_ => _i;
  static NotifyRequest create() => new NotifyRequest();
  NotifyRequest createEmptyInstance() => create();
  static $pb.PbList<NotifyRequest> createRepeated() => new $pb.PbList<NotifyRequest>();
  static NotifyRequest getDefault() => _defaultInstance ??= create()..freeze();
  static NotifyRequest _defaultInstance;
  static void $checkItem(NotifyRequest v) {
    if (v is! NotifyRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get token => $_getS(0, '');
  set token(String v) { $_setString(0, v); }
  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);

  String get registrationToken => $_getS(1, '');
  set registrationToken(String v) { $_setString(1, v); }
  bool hasRegistrationToken() => $_has(1);
  void clearRegistrationToken() => clearField(2);

  String get title => $_getS(2, '');
  set title(String v) { $_setString(2, v); }
  bool hasTitle() => $_has(2);
  void clearTitle() => clearField(3);

  String get body => $_getS(3, '');
  set body(String v) { $_setString(3, v); }
  bool hasBody() => $_has(3);
  void clearBody() => clearField(4);
}

class NotifyResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NotifyResponse', package: const $pb.PackageName('api'))
    ..hasRequiredFields = false
  ;

  NotifyResponse() : super();
  NotifyResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NotifyResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NotifyResponse clone() => new NotifyResponse()..mergeFromMessage(this);
  NotifyResponse copyWith(void Function(NotifyResponse) updates) => super.copyWith((message) => updates(message as NotifyResponse));
  $pb.BuilderInfo get info_ => _i;
  static NotifyResponse create() => new NotifyResponse();
  NotifyResponse createEmptyInstance() => create();
  static $pb.PbList<NotifyResponse> createRepeated() => new $pb.PbList<NotifyResponse>();
  static NotifyResponse getDefault() => _defaultInstance ??= create()..freeze();
  static NotifyResponse _defaultInstance;
  static void $checkItem(NotifyResponse v) {
    if (v is! NotifyResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

