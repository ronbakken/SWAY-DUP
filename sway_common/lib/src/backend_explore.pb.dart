///
//  Generated code. Do not modify.
//  source: backend_explore.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $13;
import 'net_account_protobuf.pb.dart' as $0;
import 'net_offer_protobuf.pb.dart' as $3;

class InsertProfileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InsertProfileRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataAccount>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'account',
        subBuilder: $13.DataAccount.create)
    ..hasRequiredFields = false;

  InsertProfileRequest._() : super();
  factory InsertProfileRequest() => create();
  factory InsertProfileRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InsertProfileRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InsertProfileRequest clone() =>
      InsertProfileRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InsertProfileRequest copyWith(void Function(InsertProfileRequest) updates) =>
      super.copyWith((message) => updates(
          message as InsertProfileRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InsertProfileRequest create() => InsertProfileRequest._();
  InsertProfileRequest createEmptyInstance() => create();
  static $pb.PbList<InsertProfileRequest> createRepeated() =>
      $pb.PbList<InsertProfileRequest>();
  @$core.pragma('dart2js:noInline')
  static InsertProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InsertProfileRequest>(create);
  static InsertProfileRequest _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataAccount get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($13.DataAccount v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataAccount ensureAccount() => $_ensure(0);
}

class InsertProfileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InsertProfileResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  InsertProfileResponse._() : super();
  factory InsertProfileResponse() => create();
  factory InsertProfileResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InsertProfileResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InsertProfileResponse clone() =>
      InsertProfileResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InsertProfileResponse copyWith(
          void Function(InsertProfileResponse) updates) =>
      super.copyWith((message) => updates(
          message as InsertProfileResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InsertProfileResponse create() => InsertProfileResponse._();
  InsertProfileResponse createEmptyInstance() => create();
  static $pb.PbList<InsertProfileResponse> createRepeated() =>
      $pb.PbList<InsertProfileResponse>();
  @$core.pragma('dart2js:noInline')
  static InsertProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InsertProfileResponse>(create);
  static InsertProfileResponse _defaultInstance;
}

class UpdateProfileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'UpdateProfileRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataAccount>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'account',
        subBuilder: $13.DataAccount.create)
    ..hasRequiredFields = false;

  UpdateProfileRequest._() : super();
  factory UpdateProfileRequest() => create();
  factory UpdateProfileRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UpdateProfileRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  UpdateProfileRequest clone() =>
      UpdateProfileRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  UpdateProfileRequest copyWith(void Function(UpdateProfileRequest) updates) =>
      super.copyWith((message) => updates(
          message as UpdateProfileRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateProfileRequest create() => UpdateProfileRequest._();
  UpdateProfileRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateProfileRequest> createRepeated() =>
      $pb.PbList<UpdateProfileRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProfileRequest>(create);
  static UpdateProfileRequest _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataAccount get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($13.DataAccount v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataAccount ensureAccount() => $_ensure(0);
}

class UpdateProfileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'UpdateProfileResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  UpdateProfileResponse._() : super();
  factory UpdateProfileResponse() => create();
  factory UpdateProfileResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UpdateProfileResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  UpdateProfileResponse clone() =>
      UpdateProfileResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  UpdateProfileResponse copyWith(
          void Function(UpdateProfileResponse) updates) =>
      super.copyWith((message) => updates(
          message as UpdateProfileResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateProfileResponse create() => UpdateProfileResponse._();
  UpdateProfileResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateProfileResponse> createRepeated() =>
      $pb.PbList<UpdateProfileResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProfileResponse>(create);
  static UpdateProfileResponse _defaultInstance;
}

class GetProfileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetProfileRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'accountId')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'receiverAccountId')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'private')
    ..aOB(4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'summary')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'detail')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state')
    ..hasRequiredFields = false;

  GetProfileRequest._() : super();
  factory GetProfileRequest() => create();
  factory GetProfileRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetProfileRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetProfileRequest clone() => GetProfileRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetProfileRequest copyWith(void Function(GetProfileRequest) updates) =>
      super.copyWith((message) => updates(
          message as GetProfileRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetProfileRequest create() => GetProfileRequest._();
  GetProfileRequest createEmptyInstance() => create();
  static $pb.PbList<GetProfileRequest> createRepeated() =>
      $pb.PbList<GetProfileRequest>();
  @$core.pragma('dart2js:noInline')
  static GetProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProfileRequest>(create);
  static GetProfileRequest _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get accountId => $_getI64(0);
  @$pb.TagNumber(1)
  set accountId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receiverAccountId => $_getI64(1);
  @$pb.TagNumber(2)
  set receiverAccountId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasReceiverAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiverAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get private => $_getBF(2);
  @$pb.TagNumber(3)
  set private($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrivate() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivate() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get summary => $_getBF(3);
  @$pb.TagNumber(4)
  set summary($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get detail => $_getBF(4);
  @$pb.TagNumber(5)
  set detail($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get state => $_getBF(5);
  @$pb.TagNumber(6)
  set state($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => clearField(6);
}

class GetProfileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetProfileResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$0.NetAccount>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'account',
        subBuilder: $0.NetAccount.create)
    ..hasRequiredFields = false;

  GetProfileResponse._() : super();
  factory GetProfileResponse() => create();
  factory GetProfileResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetProfileResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetProfileResponse clone() => GetProfileResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetProfileResponse copyWith(void Function(GetProfileResponse) updates) =>
      super.copyWith((message) => updates(
          message as GetProfileResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetProfileResponse create() => GetProfileResponse._();
  GetProfileResponse createEmptyInstance() => create();
  static $pb.PbList<GetProfileResponse> createRepeated() =>
      $pb.PbList<GetProfileResponse>();
  @$core.pragma('dart2js:noInline')
  static GetProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProfileResponse>(create);
  static GetProfileResponse _defaultInstance;

  @$pb.TagNumber(1)
  $0.NetAccount get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($0.NetAccount v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  $0.NetAccount ensureAccount() => $_ensure(0);
}

class InsertOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InsertOfferRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataOffer>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offer',
        subBuilder: $13.DataOffer.create)
    ..aOM<$13.DataAccount>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderAccount',
        subBuilder: $13.DataAccount.create)
    ..aOM<$13.DataLocation>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderLocation',
        subBuilder: $13.DataLocation.create)
    ..hasRequiredFields = false;

  InsertOfferRequest._() : super();
  factory InsertOfferRequest() => create();
  factory InsertOfferRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InsertOfferRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InsertOfferRequest clone() => InsertOfferRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InsertOfferRequest copyWith(void Function(InsertOfferRequest) updates) =>
      super.copyWith((message) => updates(
          message as InsertOfferRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InsertOfferRequest create() => InsertOfferRequest._();
  InsertOfferRequest createEmptyInstance() => create();
  static $pb.PbList<InsertOfferRequest> createRepeated() =>
      $pb.PbList<InsertOfferRequest>();
  @$core.pragma('dart2js:noInline')
  static InsertOfferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InsertOfferRequest>(create);
  static InsertOfferRequest _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataOffer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer($13.DataOffer v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataOffer ensureOffer() => $_ensure(0);

  @$pb.TagNumber(2)
  $13.DataAccount get senderAccount => $_getN(1);
  @$pb.TagNumber(2)
  set senderAccount($13.DataAccount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSenderAccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderAccount() => clearField(2);
  @$pb.TagNumber(2)
  $13.DataAccount ensureSenderAccount() => $_ensure(1);

  @$pb.TagNumber(3)
  $13.DataLocation get senderLocation => $_getN(2);
  @$pb.TagNumber(3)
  set senderLocation($13.DataLocation v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSenderLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderLocation() => clearField(3);
  @$pb.TagNumber(3)
  $13.DataLocation ensureSenderLocation() => $_ensure(2);
}

class InsertOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InsertOfferResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  InsertOfferResponse._() : super();
  factory InsertOfferResponse() => create();
  factory InsertOfferResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InsertOfferResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InsertOfferResponse clone() => InsertOfferResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InsertOfferResponse copyWith(void Function(InsertOfferResponse) updates) =>
      super.copyWith((message) => updates(
          message as InsertOfferResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InsertOfferResponse create() => InsertOfferResponse._();
  InsertOfferResponse createEmptyInstance() => create();
  static $pb.PbList<InsertOfferResponse> createRepeated() =>
      $pb.PbList<InsertOfferResponse>();
  @$core.pragma('dart2js:noInline')
  static InsertOfferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InsertOfferResponse>(create);
  static InsertOfferResponse _defaultInstance;
}

class UpdateOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'UpdateOfferRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataOffer>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offer',
        subBuilder: $13.DataOffer.create)
    ..hasRequiredFields = false;

  UpdateOfferRequest._() : super();
  factory UpdateOfferRequest() => create();
  factory UpdateOfferRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UpdateOfferRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  UpdateOfferRequest clone() => UpdateOfferRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  UpdateOfferRequest copyWith(void Function(UpdateOfferRequest) updates) =>
      super.copyWith((message) => updates(
          message as UpdateOfferRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateOfferRequest create() => UpdateOfferRequest._();
  UpdateOfferRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateOfferRequest> createRepeated() =>
      $pb.PbList<UpdateOfferRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateOfferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateOfferRequest>(create);
  static UpdateOfferRequest _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataOffer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer($13.DataOffer v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataOffer ensureOffer() => $_ensure(0);
}

class UpdateOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'UpdateOfferResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  UpdateOfferResponse._() : super();
  factory UpdateOfferResponse() => create();
  factory UpdateOfferResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UpdateOfferResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  UpdateOfferResponse clone() => UpdateOfferResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  UpdateOfferResponse copyWith(void Function(UpdateOfferResponse) updates) =>
      super.copyWith((message) => updates(
          message as UpdateOfferResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateOfferResponse create() => UpdateOfferResponse._();
  UpdateOfferResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateOfferResponse> createRepeated() =>
      $pb.PbList<UpdateOfferResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateOfferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateOfferResponse>(create);
  static UpdateOfferResponse _defaultInstance;
}

class GetOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetOfferRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offerId')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'receiverAccountId')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'private')
    ..aOB(4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'summary')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'detail')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state')
    ..hasRequiredFields = false;

  GetOfferRequest._() : super();
  factory GetOfferRequest() => create();
  factory GetOfferRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetOfferRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetOfferRequest clone() => GetOfferRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetOfferRequest copyWith(void Function(GetOfferRequest) updates) =>
      super.copyWith((message) =>
          updates(message as GetOfferRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetOfferRequest create() => GetOfferRequest._();
  GetOfferRequest createEmptyInstance() => create();
  static $pb.PbList<GetOfferRequest> createRepeated() =>
      $pb.PbList<GetOfferRequest>();
  @$core.pragma('dart2js:noInline')
  static GetOfferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOfferRequest>(create);
  static GetOfferRequest _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get offerId => $_getI64(0);
  @$pb.TagNumber(1)
  set offerId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOfferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOfferId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receiverAccountId => $_getI64(1);
  @$pb.TagNumber(2)
  set receiverAccountId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasReceiverAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiverAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get private => $_getBF(2);
  @$pb.TagNumber(3)
  set private($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrivate() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivate() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get summary => $_getBF(3);
  @$pb.TagNumber(4)
  set summary($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get detail => $_getBF(4);
  @$pb.TagNumber(5)
  set detail($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get state => $_getBF(5);
  @$pb.TagNumber(6)
  set state($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => clearField(6);
}

class GetOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetOfferResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$3.NetOffer>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offer',
        subBuilder: $3.NetOffer.create)
    ..hasRequiredFields = false;

  GetOfferResponse._() : super();
  factory GetOfferResponse() => create();
  factory GetOfferResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetOfferResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetOfferResponse clone() => GetOfferResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetOfferResponse copyWith(void Function(GetOfferResponse) updates) =>
      super.copyWith((message) => updates(
          message as GetOfferResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetOfferResponse create() => GetOfferResponse._();
  GetOfferResponse createEmptyInstance() => create();
  static $pb.PbList<GetOfferResponse> createRepeated() =>
      $pb.PbList<GetOfferResponse>();
  @$core.pragma('dart2js:noInline')
  static GetOfferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOfferResponse>(create);
  static GetOfferResponse _defaultInstance;

  @$pb.TagNumber(1)
  $3.NetOffer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer($3.NetOffer v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => clearField(1);
  @$pb.TagNumber(1)
  $3.NetOffer ensureOffer() => $_ensure(0);
}

class ListOffersFromSenderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListOffersFromSenderRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'accountId')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'receiverAccountId')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'private')
    ..aOB(4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'summary')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'detail')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state')
    ..hasRequiredFields = false;

  ListOffersFromSenderRequest._() : super();
  factory ListOffersFromSenderRequest() => create();
  factory ListOffersFromSenderRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListOffersFromSenderRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListOffersFromSenderRequest clone() =>
      ListOffersFromSenderRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListOffersFromSenderRequest copyWith(
          void Function(ListOffersFromSenderRequest) updates) =>
      super.copyWith((message) => updates(message
          as ListOffersFromSenderRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListOffersFromSenderRequest create() =>
      ListOffersFromSenderRequest._();
  ListOffersFromSenderRequest createEmptyInstance() => create();
  static $pb.PbList<ListOffersFromSenderRequest> createRepeated() =>
      $pb.PbList<ListOffersFromSenderRequest>();
  @$core.pragma('dart2js:noInline')
  static ListOffersFromSenderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOffersFromSenderRequest>(create);
  static ListOffersFromSenderRequest _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get accountId => $_getI64(0);
  @$pb.TagNumber(1)
  set accountId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receiverAccountId => $_getI64(1);
  @$pb.TagNumber(2)
  set receiverAccountId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasReceiverAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiverAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get private => $_getBF(2);
  @$pb.TagNumber(3)
  set private($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrivate() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivate() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get summary => $_getBF(3);
  @$pb.TagNumber(4)
  set summary($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get detail => $_getBF(4);
  @$pb.TagNumber(5)
  set detail($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get state => $_getBF(5);
  @$pb.TagNumber(6)
  set state($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => clearField(6);
}

class ListOffersFromSenderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListOffersFromSenderResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$3.NetOffer>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offer',
        subBuilder: $3.NetOffer.create)
    ..hasRequiredFields = false;

  ListOffersFromSenderResponse._() : super();
  factory ListOffersFromSenderResponse() => create();
  factory ListOffersFromSenderResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListOffersFromSenderResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListOffersFromSenderResponse clone() =>
      ListOffersFromSenderResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListOffersFromSenderResponse copyWith(
          void Function(ListOffersFromSenderResponse) updates) =>
      super.copyWith((message) => updates(message
          as ListOffersFromSenderResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListOffersFromSenderResponse create() =>
      ListOffersFromSenderResponse._();
  ListOffersFromSenderResponse createEmptyInstance() => create();
  static $pb.PbList<ListOffersFromSenderResponse> createRepeated() =>
      $pb.PbList<ListOffersFromSenderResponse>();
  @$core.pragma('dart2js:noInline')
  static ListOffersFromSenderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOffersFromSenderResponse>(create);
  static ListOffersFromSenderResponse _defaultInstance;

  @$pb.TagNumber(1)
  $3.NetOffer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer($3.NetOffer v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => clearField(1);
  @$pb.TagNumber(1)
  $3.NetOffer ensureOffer() => $_ensure(0);
}
