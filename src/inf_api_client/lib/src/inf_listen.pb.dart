///
//  Generated code. Do not modify.
//  source: inf_listen.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'item_filter.pb.dart' as $16;
import 'item.pb.dart' as $17;

import 'inf_listen.pbenum.dart';

export 'inf_listen.pbenum.dart';

class SingleItemFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SingleItemFilterDto', package: const $pb.PackageName('api'))
    ..e<SingleItemFilterDto_Type>(1, 'type', $pb.PbFieldType.OE, SingleItemFilterDto_Type.offer, SingleItemFilterDto_Type.valueOf, SingleItemFilterDto_Type.values)
    ..aOS(2, 'id')
    ..hasRequiredFields = false
  ;

  SingleItemFilterDto() : super();
  SingleItemFilterDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SingleItemFilterDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SingleItemFilterDto clone() => SingleItemFilterDto()..mergeFromMessage(this);
  SingleItemFilterDto copyWith(void Function(SingleItemFilterDto) updates) => super.copyWith((message) => updates(message as SingleItemFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static SingleItemFilterDto create() => SingleItemFilterDto();
  SingleItemFilterDto createEmptyInstance() => create();
  static $pb.PbList<SingleItemFilterDto> createRepeated() => $pb.PbList<SingleItemFilterDto>();
  static SingleItemFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static SingleItemFilterDto _defaultInstance;

  SingleItemFilterDto_Type get type => $_getN(0);
  set type(SingleItemFilterDto_Type v) { setField(1, v); }
  $core.bool hasType() => $_has(0);
  void clearType() => clearField(1);

  $core.String get id => $_getS(1, '');
  set id($core.String v) { $_setString(1, v); }
  $core.bool hasId() => $_has(1);
  void clearId() => clearField(2);
}

enum ListenRequest_Target {
  singleItemFilter, 
  filter, 
  notSet
}

class ListenRequest extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, ListenRequest_Target> _ListenRequest_TargetByTag = {
    2 : ListenRequest_Target.singleItemFilter,
    3 : ListenRequest_Target.filter,
    0 : ListenRequest_Target.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListenRequest', package: const $pb.PackageName('api'))
    ..e<ListenRequest_Action>(1, 'action', $pb.PbFieldType.OE, ListenRequest_Action.register, ListenRequest_Action.valueOf, ListenRequest_Action.values)
    ..a<SingleItemFilterDto>(2, 'singleItemFilter', $pb.PbFieldType.OM, SingleItemFilterDto.getDefault, SingleItemFilterDto.create)
    ..a<$16.ItemFilterDto>(3, 'filter', $pb.PbFieldType.OM, $16.ItemFilterDto.getDefault, $16.ItemFilterDto.create)
    ..oo(0, [2, 3])
    ..hasRequiredFields = false
  ;

  ListenRequest() : super();
  ListenRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ListenRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ListenRequest clone() => ListenRequest()..mergeFromMessage(this);
  ListenRequest copyWith(void Function(ListenRequest) updates) => super.copyWith((message) => updates(message as ListenRequest));
  $pb.BuilderInfo get info_ => _i;
  static ListenRequest create() => ListenRequest();
  ListenRequest createEmptyInstance() => create();
  static $pb.PbList<ListenRequest> createRepeated() => $pb.PbList<ListenRequest>();
  static ListenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ListenRequest _defaultInstance;

  ListenRequest_Target whichTarget() => _ListenRequest_TargetByTag[$_whichOneof(0)];
  void clearTarget() => clearField($_whichOneof(0));

  ListenRequest_Action get action => $_getN(0);
  set action(ListenRequest_Action v) { setField(1, v); }
  $core.bool hasAction() => $_has(0);
  void clearAction() => clearField(1);

  SingleItemFilterDto get singleItemFilter => $_getN(1);
  set singleItemFilter(SingleItemFilterDto v) { setField(2, v); }
  $core.bool hasSingleItemFilter() => $_has(1);
  void clearSingleItemFilter() => clearField(2);

  $16.ItemFilterDto get filter => $_getN(2);
  set filter($16.ItemFilterDto v) { setField(3, v); }
  $core.bool hasFilter() => $_has(2);
  void clearFilter() => clearField(3);
}

class ListenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListenResponse', package: const $pb.PackageName('api'))
    ..pc<$17.ItemDto>(1, 'items', $pb.PbFieldType.PM,$17.ItemDto.create)
    ..hasRequiredFields = false
  ;

  ListenResponse() : super();
  ListenResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ListenResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ListenResponse clone() => ListenResponse()..mergeFromMessage(this);
  ListenResponse copyWith(void Function(ListenResponse) updates) => super.copyWith((message) => updates(message as ListenResponse));
  $pb.BuilderInfo get info_ => _i;
  static ListenResponse create() => ListenResponse();
  ListenResponse createEmptyInstance() => create();
  static $pb.PbList<ListenResponse> createRepeated() => $pb.PbList<ListenResponse>();
  static ListenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ListenResponse _defaultInstance;

  $core.List<$17.ItemDto> get items => $_getList(0);
}

