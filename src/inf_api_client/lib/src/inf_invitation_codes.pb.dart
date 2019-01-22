///
//  Generated code. Do not modify.
//  source: inf_invitation_codes.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'inf_invitation_codes.pbenum.dart';

export 'inf_invitation_codes.pbenum.dart';

class GenerateInvitationCodeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GenerateInvitationCodeResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'invitationCode')
    ..hasRequiredFields = false
  ;

  GenerateInvitationCodeResponse() : super();
  GenerateInvitationCodeResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GenerateInvitationCodeResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GenerateInvitationCodeResponse clone() => new GenerateInvitationCodeResponse()..mergeFromMessage(this);
  GenerateInvitationCodeResponse copyWith(void Function(GenerateInvitationCodeResponse) updates) => super.copyWith((message) => updates(message as GenerateInvitationCodeResponse));
  $pb.BuilderInfo get info_ => _i;
  static GenerateInvitationCodeResponse create() => new GenerateInvitationCodeResponse();
  GenerateInvitationCodeResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateInvitationCodeResponse> createRepeated() => new $pb.PbList<GenerateInvitationCodeResponse>();
  static GenerateInvitationCodeResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GenerateInvitationCodeResponse _defaultInstance;
  static void $checkItem(GenerateInvitationCodeResponse v) {
    if (v is! GenerateInvitationCodeResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get invitationCode => $_getS(0, '');
  set invitationCode(String v) { $_setString(0, v); }
  bool hasInvitationCode() => $_has(0);
  void clearInvitationCode() => clearField(1);
}

class GetInvitationCodeStatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetInvitationCodeStatusRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'invitationCode')
    ..hasRequiredFields = false
  ;

  GetInvitationCodeStatusRequest() : super();
  GetInvitationCodeStatusRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetInvitationCodeStatusRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetInvitationCodeStatusRequest clone() => new GetInvitationCodeStatusRequest()..mergeFromMessage(this);
  GetInvitationCodeStatusRequest copyWith(void Function(GetInvitationCodeStatusRequest) updates) => super.copyWith((message) => updates(message as GetInvitationCodeStatusRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetInvitationCodeStatusRequest create() => new GetInvitationCodeStatusRequest();
  GetInvitationCodeStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetInvitationCodeStatusRequest> createRepeated() => new $pb.PbList<GetInvitationCodeStatusRequest>();
  static GetInvitationCodeStatusRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetInvitationCodeStatusRequest _defaultInstance;
  static void $checkItem(GetInvitationCodeStatusRequest v) {
    if (v is! GetInvitationCodeStatusRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get invitationCode => $_getS(0, '');
  set invitationCode(String v) { $_setString(0, v); }
  bool hasInvitationCode() => $_has(0);
  void clearInvitationCode() => clearField(1);
}

class GetInvitationCodeStatusResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetInvitationCodeStatusResponse', package: const $pb.PackageName('api'))
    ..e<GetInvitationCodeStatusResponse_InvitationCodeStatus>(1, 'status', $pb.PbFieldType.OE, GetInvitationCodeStatusResponse_InvitationCodeStatus.DOES_NOT_EXIST, GetInvitationCodeStatusResponse_InvitationCodeStatus.valueOf, GetInvitationCodeStatusResponse_InvitationCodeStatus.values)
    ..hasRequiredFields = false
  ;

  GetInvitationCodeStatusResponse() : super();
  GetInvitationCodeStatusResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetInvitationCodeStatusResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetInvitationCodeStatusResponse clone() => new GetInvitationCodeStatusResponse()..mergeFromMessage(this);
  GetInvitationCodeStatusResponse copyWith(void Function(GetInvitationCodeStatusResponse) updates) => super.copyWith((message) => updates(message as GetInvitationCodeStatusResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetInvitationCodeStatusResponse create() => new GetInvitationCodeStatusResponse();
  GetInvitationCodeStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetInvitationCodeStatusResponse> createRepeated() => new $pb.PbList<GetInvitationCodeStatusResponse>();
  static GetInvitationCodeStatusResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetInvitationCodeStatusResponse _defaultInstance;
  static void $checkItem(GetInvitationCodeStatusResponse v) {
    if (v is! GetInvitationCodeStatusResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  GetInvitationCodeStatusResponse_InvitationCodeStatus get status => $_getN(0);
  set status(GetInvitationCodeStatusResponse_InvitationCodeStatus v) { setField(1, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);
}

