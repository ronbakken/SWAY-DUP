///
//  Generated code. Do not modify.
//  source: backend_explore.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $10;
import 'net_account_protobuf.pb.dart' as $0;
import 'net_offer_protobuf.pb.dart' as $3;

class InsertProfileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InsertProfileRequest',
      package: const $pb.PackageName('inf'))
    ..a<$10.DataAccount>(1, 'account', $pb.PbFieldType.OM,
        $10.DataAccount.getDefault, $10.DataAccount.create)
    ..hasRequiredFields = false;

  InsertProfileRequest() : super();
  InsertProfileRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  InsertProfileRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  InsertProfileRequest clone() =>
      new InsertProfileRequest()..mergeFromMessage(this);
  InsertProfileRequest copyWith(void Function(InsertProfileRequest) updates) =>
      super.copyWith((message) => updates(message as InsertProfileRequest));
  $pb.BuilderInfo get info_ => _i;
  static InsertProfileRequest create() => new InsertProfileRequest();
  InsertProfileRequest createEmptyInstance() => create();
  static $pb.PbList<InsertProfileRequest> createRepeated() =>
      new $pb.PbList<InsertProfileRequest>();
  static InsertProfileRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static InsertProfileRequest _defaultInstance;
  static void $checkItem(InsertProfileRequest v) {
    if (v is! InsertProfileRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.DataAccount get account => $_getN(0);
  set account($10.DataAccount v) {
    setField(1, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(1);
}

class InsertProfileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InsertProfileResponse',
      package: const $pb.PackageName('inf'))
    ..hasRequiredFields = false;

  InsertProfileResponse() : super();
  InsertProfileResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  InsertProfileResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  InsertProfileResponse clone() =>
      new InsertProfileResponse()..mergeFromMessage(this);
  InsertProfileResponse copyWith(
          void Function(InsertProfileResponse) updates) =>
      super.copyWith((message) => updates(message as InsertProfileResponse));
  $pb.BuilderInfo get info_ => _i;
  static InsertProfileResponse create() => new InsertProfileResponse();
  InsertProfileResponse createEmptyInstance() => create();
  static $pb.PbList<InsertProfileResponse> createRepeated() =>
      new $pb.PbList<InsertProfileResponse>();
  static InsertProfileResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static InsertProfileResponse _defaultInstance;
  static void $checkItem(InsertProfileResponse v) {
    if (v is! InsertProfileResponse)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class UpdateProfileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateProfileRequest',
      package: const $pb.PackageName('inf'))
    ..a<$10.DataAccount>(1, 'account', $pb.PbFieldType.OM,
        $10.DataAccount.getDefault, $10.DataAccount.create)
    ..hasRequiredFields = false;

  UpdateProfileRequest() : super();
  UpdateProfileRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UpdateProfileRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UpdateProfileRequest clone() =>
      new UpdateProfileRequest()..mergeFromMessage(this);
  UpdateProfileRequest copyWith(void Function(UpdateProfileRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateProfileRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateProfileRequest create() => new UpdateProfileRequest();
  UpdateProfileRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateProfileRequest> createRepeated() =>
      new $pb.PbList<UpdateProfileRequest>();
  static UpdateProfileRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UpdateProfileRequest _defaultInstance;
  static void $checkItem(UpdateProfileRequest v) {
    if (v is! UpdateProfileRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.DataAccount get account => $_getN(0);
  set account($10.DataAccount v) {
    setField(1, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(1);
}

class UpdateProfileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateProfileResponse',
      package: const $pb.PackageName('inf'))
    ..hasRequiredFields = false;

  UpdateProfileResponse() : super();
  UpdateProfileResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UpdateProfileResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UpdateProfileResponse clone() =>
      new UpdateProfileResponse()..mergeFromMessage(this);
  UpdateProfileResponse copyWith(
          void Function(UpdateProfileResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateProfileResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateProfileResponse create() => new UpdateProfileResponse();
  UpdateProfileResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateProfileResponse> createRepeated() =>
      new $pb.PbList<UpdateProfileResponse>();
  static UpdateProfileResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UpdateProfileResponse _defaultInstance;
  static void $checkItem(UpdateProfileResponse v) {
    if (v is! UpdateProfileResponse)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class GetProfileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetProfileRequest',
      package: const $pb.PackageName('inf'))
    ..aInt64(1, 'accountId')
    ..aInt64(2, 'receiverAccountId')
    ..aOB(3, 'private')
    ..aOB(4, 'summary')
    ..aOB(5, 'detail')
    ..aOB(6, 'state')
    ..hasRequiredFields = false;

  GetProfileRequest() : super();
  GetProfileRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GetProfileRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GetProfileRequest clone() => new GetProfileRequest()..mergeFromMessage(this);
  GetProfileRequest copyWith(void Function(GetProfileRequest) updates) =>
      super.copyWith((message) => updates(message as GetProfileRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetProfileRequest create() => new GetProfileRequest();
  GetProfileRequest createEmptyInstance() => create();
  static $pb.PbList<GetProfileRequest> createRepeated() =>
      new $pb.PbList<GetProfileRequest>();
  static GetProfileRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static GetProfileRequest _defaultInstance;
  static void $checkItem(GetProfileRequest v) {
    if (v is! GetProfileRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get accountId => $_getI64(0);
  set accountId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasAccountId() => $_has(0);
  void clearAccountId() => clearField(1);

  Int64 get receiverAccountId => $_getI64(1);
  set receiverAccountId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasReceiverAccountId() => $_has(1);
  void clearReceiverAccountId() => clearField(2);

  bool get private => $_get(2, false);
  set private(bool v) {
    $_setBool(2, v);
  }

  bool hasPrivate() => $_has(2);
  void clearPrivate() => clearField(3);

  bool get summary => $_get(3, false);
  set summary(bool v) {
    $_setBool(3, v);
  }

  bool hasSummary() => $_has(3);
  void clearSummary() => clearField(4);

  bool get detail => $_get(4, false);
  set detail(bool v) {
    $_setBool(4, v);
  }

  bool hasDetail() => $_has(4);
  void clearDetail() => clearField(5);

  bool get state => $_get(5, false);
  set state(bool v) {
    $_setBool(5, v);
  }

  bool hasState() => $_has(5);
  void clearState() => clearField(6);
}

class GetProfileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetProfileResponse',
      package: const $pb.PackageName('inf'))
    ..a<$0.NetAccount>(1, 'account', $pb.PbFieldType.OM,
        $0.NetAccount.getDefault, $0.NetAccount.create)
    ..hasRequiredFields = false;

  GetProfileResponse() : super();
  GetProfileResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GetProfileResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GetProfileResponse clone() =>
      new GetProfileResponse()..mergeFromMessage(this);
  GetProfileResponse copyWith(void Function(GetProfileResponse) updates) =>
      super.copyWith((message) => updates(message as GetProfileResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetProfileResponse create() => new GetProfileResponse();
  GetProfileResponse createEmptyInstance() => create();
  static $pb.PbList<GetProfileResponse> createRepeated() =>
      new $pb.PbList<GetProfileResponse>();
  static GetProfileResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static GetProfileResponse _defaultInstance;
  static void $checkItem(GetProfileResponse v) {
    if (v is! GetProfileResponse)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $0.NetAccount get account => $_getN(0);
  set account($0.NetAccount v) {
    setField(1, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(1);
}

class InsertOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InsertOfferRequest',
      package: const $pb.PackageName('inf'))
    ..a<$10.DataOffer>(1, 'offer', $pb.PbFieldType.OM, $10.DataOffer.getDefault,
        $10.DataOffer.create)
    ..a<$10.DataAccount>(2, 'senderAccount', $pb.PbFieldType.OM,
        $10.DataAccount.getDefault, $10.DataAccount.create)
    ..a<$10.DataLocation>(3, 'senderLocation', $pb.PbFieldType.OM,
        $10.DataLocation.getDefault, $10.DataLocation.create)
    ..hasRequiredFields = false;

  InsertOfferRequest() : super();
  InsertOfferRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  InsertOfferRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  InsertOfferRequest clone() =>
      new InsertOfferRequest()..mergeFromMessage(this);
  InsertOfferRequest copyWith(void Function(InsertOfferRequest) updates) =>
      super.copyWith((message) => updates(message as InsertOfferRequest));
  $pb.BuilderInfo get info_ => _i;
  static InsertOfferRequest create() => new InsertOfferRequest();
  InsertOfferRequest createEmptyInstance() => create();
  static $pb.PbList<InsertOfferRequest> createRepeated() =>
      new $pb.PbList<InsertOfferRequest>();
  static InsertOfferRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static InsertOfferRequest _defaultInstance;
  static void $checkItem(InsertOfferRequest v) {
    if (v is! InsertOfferRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.DataOffer get offer => $_getN(0);
  set offer($10.DataOffer v) {
    setField(1, v);
  }

  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);

  $10.DataAccount get senderAccount => $_getN(1);
  set senderAccount($10.DataAccount v) {
    setField(2, v);
  }

  bool hasSenderAccount() => $_has(1);
  void clearSenderAccount() => clearField(2);

  $10.DataLocation get senderLocation => $_getN(2);
  set senderLocation($10.DataLocation v) {
    setField(3, v);
  }

  bool hasSenderLocation() => $_has(2);
  void clearSenderLocation() => clearField(3);
}

class InsertOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InsertOfferResponse',
      package: const $pb.PackageName('inf'))
    ..hasRequiredFields = false;

  InsertOfferResponse() : super();
  InsertOfferResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  InsertOfferResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  InsertOfferResponse clone() =>
      new InsertOfferResponse()..mergeFromMessage(this);
  InsertOfferResponse copyWith(void Function(InsertOfferResponse) updates) =>
      super.copyWith((message) => updates(message as InsertOfferResponse));
  $pb.BuilderInfo get info_ => _i;
  static InsertOfferResponse create() => new InsertOfferResponse();
  InsertOfferResponse createEmptyInstance() => create();
  static $pb.PbList<InsertOfferResponse> createRepeated() =>
      new $pb.PbList<InsertOfferResponse>();
  static InsertOfferResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static InsertOfferResponse _defaultInstance;
  static void $checkItem(InsertOfferResponse v) {
    if (v is! InsertOfferResponse)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class UpdateOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateOfferRequest',
      package: const $pb.PackageName('inf'))
    ..a<$10.DataOffer>(1, 'offer', $pb.PbFieldType.OM, $10.DataOffer.getDefault,
        $10.DataOffer.create)
    ..hasRequiredFields = false;

  UpdateOfferRequest() : super();
  UpdateOfferRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UpdateOfferRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UpdateOfferRequest clone() =>
      new UpdateOfferRequest()..mergeFromMessage(this);
  UpdateOfferRequest copyWith(void Function(UpdateOfferRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateOfferRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateOfferRequest create() => new UpdateOfferRequest();
  UpdateOfferRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateOfferRequest> createRepeated() =>
      new $pb.PbList<UpdateOfferRequest>();
  static UpdateOfferRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UpdateOfferRequest _defaultInstance;
  static void $checkItem(UpdateOfferRequest v) {
    if (v is! UpdateOfferRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.DataOffer get offer => $_getN(0);
  set offer($10.DataOffer v) {
    setField(1, v);
  }

  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class UpdateOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateOfferResponse',
      package: const $pb.PackageName('inf'))
    ..hasRequiredFields = false;

  UpdateOfferResponse() : super();
  UpdateOfferResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UpdateOfferResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UpdateOfferResponse clone() =>
      new UpdateOfferResponse()..mergeFromMessage(this);
  UpdateOfferResponse copyWith(void Function(UpdateOfferResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateOfferResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateOfferResponse create() => new UpdateOfferResponse();
  UpdateOfferResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateOfferResponse> createRepeated() =>
      new $pb.PbList<UpdateOfferResponse>();
  static UpdateOfferResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UpdateOfferResponse _defaultInstance;
  static void $checkItem(UpdateOfferResponse v) {
    if (v is! UpdateOfferResponse)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class GetOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetOfferRequest',
      package: const $pb.PackageName('inf'))
    ..aInt64(1, 'offerId')
    ..aInt64(2, 'receiverAccountId')
    ..aOB(3, 'private')
    ..aOB(4, 'summary')
    ..aOB(5, 'detail')
    ..aOB(6, 'state')
    ..hasRequiredFields = false;

  GetOfferRequest() : super();
  GetOfferRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GetOfferRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GetOfferRequest clone() => new GetOfferRequest()..mergeFromMessage(this);
  GetOfferRequest copyWith(void Function(GetOfferRequest) updates) =>
      super.copyWith((message) => updates(message as GetOfferRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetOfferRequest create() => new GetOfferRequest();
  GetOfferRequest createEmptyInstance() => create();
  static $pb.PbList<GetOfferRequest> createRepeated() =>
      new $pb.PbList<GetOfferRequest>();
  static GetOfferRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static GetOfferRequest _defaultInstance;
  static void $checkItem(GetOfferRequest v) {
    if (v is! GetOfferRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get offerId => $_getI64(0);
  set offerId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  Int64 get receiverAccountId => $_getI64(1);
  set receiverAccountId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasReceiverAccountId() => $_has(1);
  void clearReceiverAccountId() => clearField(2);

  bool get private => $_get(2, false);
  set private(bool v) {
    $_setBool(2, v);
  }

  bool hasPrivate() => $_has(2);
  void clearPrivate() => clearField(3);

  bool get summary => $_get(3, false);
  set summary(bool v) {
    $_setBool(3, v);
  }

  bool hasSummary() => $_has(3);
  void clearSummary() => clearField(4);

  bool get detail => $_get(4, false);
  set detail(bool v) {
    $_setBool(4, v);
  }

  bool hasDetail() => $_has(4);
  void clearDetail() => clearField(5);

  bool get state => $_get(5, false);
  set state(bool v) {
    $_setBool(5, v);
  }

  bool hasState() => $_has(5);
  void clearState() => clearField(6);
}

class GetOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetOfferResponse',
      package: const $pb.PackageName('inf'))
    ..a<$3.NetOffer>(1, 'offer', $pb.PbFieldType.OM, $3.NetOffer.getDefault,
        $3.NetOffer.create)
    ..hasRequiredFields = false;

  GetOfferResponse() : super();
  GetOfferResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GetOfferResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GetOfferResponse clone() => new GetOfferResponse()..mergeFromMessage(this);
  GetOfferResponse copyWith(void Function(GetOfferResponse) updates) =>
      super.copyWith((message) => updates(message as GetOfferResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetOfferResponse create() => new GetOfferResponse();
  GetOfferResponse createEmptyInstance() => create();
  static $pb.PbList<GetOfferResponse> createRepeated() =>
      new $pb.PbList<GetOfferResponse>();
  static GetOfferResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static GetOfferResponse _defaultInstance;
  static void $checkItem(GetOfferResponse v) {
    if (v is! GetOfferResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $3.NetOffer get offer => $_getN(0);
  set offer($3.NetOffer v) {
    setField(1, v);
  }

  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class ListOffersFromSenderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'ListOffersFromSenderRequest',
      package: const $pb.PackageName('inf'))
    ..aInt64(1, 'accountId')
    ..aInt64(2, 'receiverAccountId')
    ..aOB(3, 'private')
    ..aOB(4, 'summary')
    ..aOB(5, 'detail')
    ..aOB(6, 'state')
    ..hasRequiredFields = false;

  ListOffersFromSenderRequest() : super();
  ListOffersFromSenderRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ListOffersFromSenderRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ListOffersFromSenderRequest clone() =>
      new ListOffersFromSenderRequest()..mergeFromMessage(this);
  ListOffersFromSenderRequest copyWith(
          void Function(ListOffersFromSenderRequest) updates) =>
      super.copyWith(
          (message) => updates(message as ListOffersFromSenderRequest));
  $pb.BuilderInfo get info_ => _i;
  static ListOffersFromSenderRequest create() =>
      new ListOffersFromSenderRequest();
  ListOffersFromSenderRequest createEmptyInstance() => create();
  static $pb.PbList<ListOffersFromSenderRequest> createRepeated() =>
      new $pb.PbList<ListOffersFromSenderRequest>();
  static ListOffersFromSenderRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ListOffersFromSenderRequest _defaultInstance;
  static void $checkItem(ListOffersFromSenderRequest v) {
    if (v is! ListOffersFromSenderRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get accountId => $_getI64(0);
  set accountId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasAccountId() => $_has(0);
  void clearAccountId() => clearField(1);

  Int64 get receiverAccountId => $_getI64(1);
  set receiverAccountId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasReceiverAccountId() => $_has(1);
  void clearReceiverAccountId() => clearField(2);

  bool get private => $_get(2, false);
  set private(bool v) {
    $_setBool(2, v);
  }

  bool hasPrivate() => $_has(2);
  void clearPrivate() => clearField(3);

  bool get summary => $_get(3, false);
  set summary(bool v) {
    $_setBool(3, v);
  }

  bool hasSummary() => $_has(3);
  void clearSummary() => clearField(4);

  bool get detail => $_get(4, false);
  set detail(bool v) {
    $_setBool(4, v);
  }

  bool hasDetail() => $_has(4);
  void clearDetail() => clearField(5);

  bool get state => $_get(5, false);
  set state(bool v) {
    $_setBool(5, v);
  }

  bool hasState() => $_has(5);
  void clearState() => clearField(6);
}

class ListOffersFromSenderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'ListOffersFromSenderResponse',
      package: const $pb.PackageName('inf'))
    ..a<$3.NetOffer>(1, 'offer', $pb.PbFieldType.OM, $3.NetOffer.getDefault,
        $3.NetOffer.create)
    ..hasRequiredFields = false;

  ListOffersFromSenderResponse() : super();
  ListOffersFromSenderResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ListOffersFromSenderResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ListOffersFromSenderResponse clone() =>
      new ListOffersFromSenderResponse()..mergeFromMessage(this);
  ListOffersFromSenderResponse copyWith(
          void Function(ListOffersFromSenderResponse) updates) =>
      super.copyWith(
          (message) => updates(message as ListOffersFromSenderResponse));
  $pb.BuilderInfo get info_ => _i;
  static ListOffersFromSenderResponse create() =>
      new ListOffersFromSenderResponse();
  ListOffersFromSenderResponse createEmptyInstance() => create();
  static $pb.PbList<ListOffersFromSenderResponse> createRepeated() =>
      new $pb.PbList<ListOffersFromSenderResponse>();
  static ListOffersFromSenderResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ListOffersFromSenderResponse _defaultInstance;
  static void $checkItem(ListOffersFromSenderResponse v) {
    if (v is! ListOffersFromSenderResponse)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $3.NetOffer get offer => $_getN(0);
  set offer($3.NetOffer v) {
    setField(1, v);
  }

  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}
