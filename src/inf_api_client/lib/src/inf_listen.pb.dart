///
//  Generated code. Do not modify.
//  source: inf_listen.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'item_filter.pb.dart' as $16;
import 'item.pb.dart' as $17;

import 'inf_listen.pbenum.dart';

export 'inf_listen.pbenum.dart';

class SingleItemFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SingleItemFilterDto', package: const $pb.PackageName('api'))
    ..e<SingleItemFilterDto_Type>(1, 'type', $pb.PbFieldType.OE, SingleItemFilterDto_Type.offer, SingleItemFilterDto_Type.valueOf, SingleItemFilterDto_Type.values)
    ..aOS(2, 'id')
    ..hasRequiredFields = false
  ;

  SingleItemFilterDto() : super();
  SingleItemFilterDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SingleItemFilterDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SingleItemFilterDto clone() => new SingleItemFilterDto()..mergeFromMessage(this);
  SingleItemFilterDto copyWith(void Function(SingleItemFilterDto) updates) => super.copyWith((message) => updates(message as SingleItemFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static SingleItemFilterDto create() => new SingleItemFilterDto();
  SingleItemFilterDto createEmptyInstance() => create();
  static $pb.PbList<SingleItemFilterDto> createRepeated() => new $pb.PbList<SingleItemFilterDto>();
  static SingleItemFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static SingleItemFilterDto _defaultInstance;
  static void $checkItem(SingleItemFilterDto v) {
    if (v is! SingleItemFilterDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  SingleItemFilterDto_Type get type => $_getN(0);
  set type(SingleItemFilterDto_Type v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  String get id => $_getS(1, '');
  set id(String v) { $_setString(1, v); }
  bool hasId() => $_has(1);
  void clearId() => clearField(2);
}

enum ListenRequest_Target {
  singleItemFilter, 
  filter, 
  notSet
}

class ListenRequest extends $pb.GeneratedMessage {
  static const Map<int, ListenRequest_Target> _ListenRequest_TargetByTag = {
    2 : ListenRequest_Target.singleItemFilter,
    3 : ListenRequest_Target.filter,
    0 : ListenRequest_Target.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ListenRequest', package: const $pb.PackageName('api'))
    ..e<ListenRequest_Action>(1, 'action', $pb.PbFieldType.OE, ListenRequest_Action.register, ListenRequest_Action.valueOf, ListenRequest_Action.values)
    ..a<SingleItemFilterDto>(2, 'singleItemFilter', $pb.PbFieldType.OM, SingleItemFilterDto.getDefault, SingleItemFilterDto.create)
    ..a<$16.ItemFilterDto>(3, 'filter', $pb.PbFieldType.OM, $16.ItemFilterDto.getDefault, $16.ItemFilterDto.create)
    ..oo(0, [2, 3])
    ..hasRequiredFields = false
  ;

  ListenRequest() : super();
  ListenRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ListenRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ListenRequest clone() => new ListenRequest()..mergeFromMessage(this);
  ListenRequest copyWith(void Function(ListenRequest) updates) => super.copyWith((message) => updates(message as ListenRequest));
  $pb.BuilderInfo get info_ => _i;
  static ListenRequest create() => new ListenRequest();
  ListenRequest createEmptyInstance() => create();
  static $pb.PbList<ListenRequest> createRepeated() => new $pb.PbList<ListenRequest>();
  static ListenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ListenRequest _defaultInstance;
  static void $checkItem(ListenRequest v) {
    if (v is! ListenRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  ListenRequest_Target whichTarget() => _ListenRequest_TargetByTag[$_whichOneof(0)];
  void clearTarget() => clearField($_whichOneof(0));

  ListenRequest_Action get action => $_getN(0);
  set action(ListenRequest_Action v) { setField(1, v); }
  bool hasAction() => $_has(0);
  void clearAction() => clearField(1);

  SingleItemFilterDto get singleItemFilter => $_getN(1);
  set singleItemFilter(SingleItemFilterDto v) { setField(2, v); }
  bool hasSingleItemFilter() => $_has(1);
  void clearSingleItemFilter() => clearField(2);

  $16.ItemFilterDto get filter => $_getN(2);
  set filter($16.ItemFilterDto v) { setField(3, v); }
  bool hasFilter() => $_has(2);
  void clearFilter() => clearField(3);
}

class ListenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ListenResponse', package: const $pb.PackageName('api'))
    ..pp<$17.ItemDto>(1, 'items', $pb.PbFieldType.PM, $17.ItemDto.$checkItem, $17.ItemDto.create)
    ..hasRequiredFields = false
  ;

  ListenResponse() : super();
  ListenResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ListenResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ListenResponse clone() => new ListenResponse()..mergeFromMessage(this);
  ListenResponse copyWith(void Function(ListenResponse) updates) => super.copyWith((message) => updates(message as ListenResponse));
  $pb.BuilderInfo get info_ => _i;
  static ListenResponse create() => new ListenResponse();
  ListenResponse createEmptyInstance() => create();
  static $pb.PbList<ListenResponse> createRepeated() => new $pb.PbList<ListenResponse>();
  static ListenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ListenResponse _defaultInstance;
  static void $checkItem(ListenResponse v) {
    if (v is! ListenResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<$17.ItemDto> get items => $_getList(0);
}

