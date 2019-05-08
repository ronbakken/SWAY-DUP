///
//  Generated code. Do not modify.
//  source: inf_list.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'item_filter.pb.dart' as $16;
import 'item.pb.dart' as $17;

import 'inf_list.pbenum.dart';

export 'inf_list.pbenum.dart';

class ListRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListRequest', package: const $pb.PackageName('api'))
    ..a<$16.ItemFilterDto>(1, 'filter', $pb.PbFieldType.OM, $16.ItemFilterDto.getDefault, $16.ItemFilterDto.create)
    ..e<ListRequest_State>(2, 'state', $pb.PbFieldType.OE, ListRequest_State.paused, ListRequest_State.valueOf, ListRequest_State.values)
    ..hasRequiredFields = false
  ;

  ListRequest() : super();
  ListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ListRequest clone() => ListRequest()..mergeFromMessage(this);
  ListRequest copyWith(void Function(ListRequest) updates) => super.copyWith((message) => updates(message as ListRequest));
  $pb.BuilderInfo get info_ => _i;
  static ListRequest create() => ListRequest();
  ListRequest createEmptyInstance() => create();
  static $pb.PbList<ListRequest> createRepeated() => $pb.PbList<ListRequest>();
  static ListRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ListRequest _defaultInstance;

  $16.ItemFilterDto get filter => $_getN(0);
  set filter($16.ItemFilterDto v) { setField(1, v); }
  $core.bool hasFilter() => $_has(0);
  void clearFilter() => clearField(1);

  ListRequest_State get state => $_getN(1);
  set state(ListRequest_State v) { setField(2, v); }
  $core.bool hasState() => $_has(1);
  void clearState() => clearField(2);
}

class ListResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListResponse', package: const $pb.PackageName('api'))
    ..pc<$17.ItemDto>(1, 'items', $pb.PbFieldType.PM,$17.ItemDto.create)
    ..hasRequiredFields = false
  ;

  ListResponse() : super();
  ListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ListResponse clone() => ListResponse()..mergeFromMessage(this);
  ListResponse copyWith(void Function(ListResponse) updates) => super.copyWith((message) => updates(message as ListResponse));
  $pb.BuilderInfo get info_ => _i;
  static ListResponse create() => ListResponse();
  ListResponse createEmptyInstance() => create();
  static $pb.PbList<ListResponse> createRepeated() => $pb.PbList<ListResponse>();
  static ListResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ListResponse _defaultInstance;

  $core.List<$17.ItemDto> get items => $_getList(0);
}

