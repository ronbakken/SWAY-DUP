///
//  Generated code. Do not modify.
//  source: inf_invitation_codes.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'inf_invitation_codes.pbenum.dart';

export 'inf_invitation_codes.pbenum.dart';

class GenerateInvitationCodeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GenerateInvitationCodeResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'invitationCode')
    ..hasRequiredFields = false
  ;

  GenerateInvitationCodeResponse() : super();
  GenerateInvitationCodeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GenerateInvitationCodeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GenerateInvitationCodeResponse clone() => GenerateInvitationCodeResponse()..mergeFromMessage(this);
  GenerateInvitationCodeResponse copyWith(void Function(GenerateInvitationCodeResponse) updates) => super.copyWith((message) => updates(message as GenerateInvitationCodeResponse));
  $pb.BuilderInfo get info_ => _i;
  static GenerateInvitationCodeResponse create() => GenerateInvitationCodeResponse();
  GenerateInvitationCodeResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateInvitationCodeResponse> createRepeated() => $pb.PbList<GenerateInvitationCodeResponse>();
  static GenerateInvitationCodeResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GenerateInvitationCodeResponse _defaultInstance;

  $core.String get invitationCode => $_getS(0, '');
  set invitationCode($core.String v) { $_setString(0, v); }
  $core.bool hasInvitationCode() => $_has(0);
  void clearInvitationCode() => clearField(1);
}

class GetInvitationCodeStatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetInvitationCodeStatusRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'invitationCode')
    ..hasRequiredFields = false
  ;

  GetInvitationCodeStatusRequest() : super();
  GetInvitationCodeStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetInvitationCodeStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetInvitationCodeStatusRequest clone() => GetInvitationCodeStatusRequest()..mergeFromMessage(this);
  GetInvitationCodeStatusRequest copyWith(void Function(GetInvitationCodeStatusRequest) updates) => super.copyWith((message) => updates(message as GetInvitationCodeStatusRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetInvitationCodeStatusRequest create() => GetInvitationCodeStatusRequest();
  GetInvitationCodeStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetInvitationCodeStatusRequest> createRepeated() => $pb.PbList<GetInvitationCodeStatusRequest>();
  static GetInvitationCodeStatusRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetInvitationCodeStatusRequest _defaultInstance;

  $core.String get invitationCode => $_getS(0, '');
  set invitationCode($core.String v) { $_setString(0, v); }
  $core.bool hasInvitationCode() => $_has(0);
  void clearInvitationCode() => clearField(1);
}

class GetInvitationCodeStatusResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetInvitationCodeStatusResponse', package: const $pb.PackageName('api'))
    ..e<GetInvitationCodeStatusResponse_InvitationCodeStatus>(1, 'status', $pb.PbFieldType.OE, GetInvitationCodeStatusResponse_InvitationCodeStatus.DOES_NOT_EXIST, GetInvitationCodeStatusResponse_InvitationCodeStatus.valueOf, GetInvitationCodeStatusResponse_InvitationCodeStatus.values)
    ..hasRequiredFields = false
  ;

  GetInvitationCodeStatusResponse() : super();
  GetInvitationCodeStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetInvitationCodeStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetInvitationCodeStatusResponse clone() => GetInvitationCodeStatusResponse()..mergeFromMessage(this);
  GetInvitationCodeStatusResponse copyWith(void Function(GetInvitationCodeStatusResponse) updates) => super.copyWith((message) => updates(message as GetInvitationCodeStatusResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetInvitationCodeStatusResponse create() => GetInvitationCodeStatusResponse();
  GetInvitationCodeStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetInvitationCodeStatusResponse> createRepeated() => $pb.PbList<GetInvitationCodeStatusResponse>();
  static GetInvitationCodeStatusResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetInvitationCodeStatusResponse _defaultInstance;

  GetInvitationCodeStatusResponse_InvitationCodeStatus get status => $_getN(0);
  set status(GetInvitationCodeStatusResponse_InvitationCodeStatus v) { setField(1, v); }
  $core.bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);
}

