///
//  Generated code. Do not modify.
//  source: inf_listen.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'item_filter.pb.dart' as $14;
import 'item.pb.dart' as $15;

import 'inf_listen.pbenum.dart';

export 'inf_listen.pbenum.dart';

enum ListenRequest_Target {
  itemId, 
  filter, 
  notSet
}

class ListenRequest extends $pb.GeneratedMessage {
  static const Map<int, ListenRequest_Target> _ListenRequest_TargetByTag = {
    2 : ListenRequest_Target.itemId,
    3 : ListenRequest_Target.filter,
    0 : ListenRequest_Target.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ListenRequest', package: const $pb.PackageName('api'))
    ..e<ListenRequest_Action>(1, 'action', $pb.PbFieldType.OE, ListenRequest_Action.register, ListenRequest_Action.valueOf, ListenRequest_Action.values)
    ..aOS(2, 'itemId')
    ..a<$14.ItemFilterDto>(3, 'filter', $pb.PbFieldType.OM, $14.ItemFilterDto.getDefault, $14.ItemFilterDto.create)
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

  String get itemId => $_getS(1, '');
  set itemId(String v) { $_setString(1, v); }
  bool hasItemId() => $_has(1);
  void clearItemId() => clearField(2);

  $14.ItemFilterDto get filter => $_getN(2);
  set filter($14.ItemFilterDto v) { setField(3, v); }
  bool hasFilter() => $_has(2);
  void clearFilter() => clearField(3);
}

class ListenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ListenResponse', package: const $pb.PackageName('api'))
    ..pp<$15.ItemDto>(1, 'items', $pb.PbFieldType.PM, $15.ItemDto.$checkItem, $15.ItemDto.create)
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

  List<$15.ItemDto> get items => $_getList(0);
}

