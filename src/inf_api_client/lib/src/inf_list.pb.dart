///
//  Generated code. Do not modify.
//  source: inf_list.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'item_filter.pb.dart' as $14;
import 'item.pb.dart' as $15;

import 'inf_list.pbenum.dart';

export 'inf_list.pbenum.dart';

class ListRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ListRequest', package: const $pb.PackageName('api'))
    ..a<$14.ItemFilterDto>(1, 'filter', $pb.PbFieldType.OM, $14.ItemFilterDto.getDefault, $14.ItemFilterDto.create)
    ..e<ListRequest_State>(2, 'state', $pb.PbFieldType.OE, ListRequest_State.paused, ListRequest_State.valueOf, ListRequest_State.values)
    ..hasRequiredFields = false
  ;

  ListRequest() : super();
  ListRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ListRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ListRequest clone() => new ListRequest()..mergeFromMessage(this);
  ListRequest copyWith(void Function(ListRequest) updates) => super.copyWith((message) => updates(message as ListRequest));
  $pb.BuilderInfo get info_ => _i;
  static ListRequest create() => new ListRequest();
  ListRequest createEmptyInstance() => create();
  static $pb.PbList<ListRequest> createRepeated() => new $pb.PbList<ListRequest>();
  static ListRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ListRequest _defaultInstance;
  static void $checkItem(ListRequest v) {
    if (v is! ListRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $14.ItemFilterDto get filter => $_getN(0);
  set filter($14.ItemFilterDto v) { setField(1, v); }
  bool hasFilter() => $_has(0);
  void clearFilter() => clearField(1);

  ListRequest_State get state => $_getN(1);
  set state(ListRequest_State v) { setField(2, v); }
  bool hasState() => $_has(1);
  void clearState() => clearField(2);
}

class ListResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ListResponse', package: const $pb.PackageName('api'))
    ..pp<$15.ItemDto>(1, 'items', $pb.PbFieldType.PM, $15.ItemDto.$checkItem, $15.ItemDto.create)
    ..hasRequiredFields = false
  ;

  ListResponse() : super();
  ListResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ListResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ListResponse clone() => new ListResponse()..mergeFromMessage(this);
  ListResponse copyWith(void Function(ListResponse) updates) => super.copyWith((message) => updates(message as ListResponse));
  $pb.BuilderInfo get info_ => _i;
  static ListResponse create() => new ListResponse();
  ListResponse createEmptyInstance() => create();
  static $pb.PbList<ListResponse> createRepeated() => new $pb.PbList<ListResponse>();
  static ListResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ListResponse _defaultInstance;
  static void $checkItem(ListResponse v) {
    if (v is! ListResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<$15.ItemDto> get items => $_getList(0);
}

