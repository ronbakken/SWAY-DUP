///
//  Generated code. Do not modify.
//  source: offer.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class OfferDto_Status extends $pb.ProtobufEnum {
  static const OfferDto_Status unknown = const OfferDto_Status._(0, 'unknown');
  static const OfferDto_Status active = const OfferDto_Status._(1, 'active');
  static const OfferDto_Status inactive = const OfferDto_Status._(2, 'inactive');
  static const OfferDto_Status closed = const OfferDto_Status._(3, 'closed');
  static const OfferDto_Status archived = const OfferDto_Status._(4, 'archived');

  static const List<OfferDto_Status> values = const <OfferDto_Status> [
    unknown,
    active,
    inactive,
    closed,
    archived,
  ];

  static final Map<int, OfferDto_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferDto_Status valueOf(int value) => _byValue[value];
  static void $checkItem(OfferDto_Status v) {
    if (v is! OfferDto_Status) $pb.checkItemFailed(v, 'OfferDto_Status');
  }

  const OfferDto_Status._(int v, String n) : super(v, n);
}

class OfferDto_StatusReason extends $pb.ProtobufEnum {
  static const OfferDto_StatusReason open = const OfferDto_StatusReason._(0, 'open');
  static const OfferDto_StatusReason userClosed = const OfferDto_StatusReason._(1, 'userClosed');
  static const OfferDto_StatusReason maximumReached = const OfferDto_StatusReason._(2, 'maximumReached');
  static const OfferDto_StatusReason tosViolation = const OfferDto_StatusReason._(3, 'tosViolation');
  static const OfferDto_StatusReason completed = const OfferDto_StatusReason._(4, 'completed');
  static const OfferDto_StatusReason expired = const OfferDto_StatusReason._(5, 'expired');

  static const List<OfferDto_StatusReason> values = const <OfferDto_StatusReason> [
    open,
    userClosed,
    maximumReached,
    tosViolation,
    completed,
    expired,
  ];

  static final Map<int, OfferDto_StatusReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferDto_StatusReason valueOf(int value) => _byValue[value];
  static void $checkItem(OfferDto_StatusReason v) {
    if (v is! OfferDto_StatusReason) $pb.checkItemFailed(v, 'OfferDto_StatusReason');
  }

  const OfferDto_StatusReason._(int v, String n) : super(v, n);
}

class OfferDto_ProposalStatus extends $pb.ProtobufEnum {
  static const OfferDto_ProposalStatus none = const OfferDto_ProposalStatus._(0, 'none');
  static const OfferDto_ProposalStatus atLeastOne = const OfferDto_ProposalStatus._(1, 'atLeastOne');
  static const OfferDto_ProposalStatus atLeastOneIncludingCurrentUser = const OfferDto_ProposalStatus._(2, 'atLeastOneIncludingCurrentUser');

  static const List<OfferDto_ProposalStatus> values = const <OfferDto_ProposalStatus> [
    none,
    atLeastOne,
    atLeastOneIncludingCurrentUser,
  ];

  static final Map<int, OfferDto_ProposalStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferDto_ProposalStatus valueOf(int value) => _byValue[value];
  static void $checkItem(OfferDto_ProposalStatus v) {
    if (v is! OfferDto_ProposalStatus) $pb.checkItemFailed(v, 'OfferDto_ProposalStatus');
  }

  const OfferDto_ProposalStatus._(int v, String n) : super(v, n);
}

class OfferDto_AcceptancePolicy extends $pb.ProtobufEnum {
  static const OfferDto_AcceptancePolicy manualReview = const OfferDto_AcceptancePolicy._(0, 'manualReview');
  static const OfferDto_AcceptancePolicy automaticAcceptMatching = const OfferDto_AcceptancePolicy._(1, 'automaticAcceptMatching');
  static const OfferDto_AcceptancePolicy allowNegotiation = const OfferDto_AcceptancePolicy._(2, 'allowNegotiation');

  static const List<OfferDto_AcceptancePolicy> values = const <OfferDto_AcceptancePolicy> [
    manualReview,
    automaticAcceptMatching,
    allowNegotiation,
  ];

  static final Map<int, OfferDto_AcceptancePolicy> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferDto_AcceptancePolicy valueOf(int value) => _byValue[value];
  static void $checkItem(OfferDto_AcceptancePolicy v) {
    if (v is! OfferDto_AcceptancePolicy) $pb.checkItemFailed(v, 'OfferDto_AcceptancePolicy');
  }

  const OfferDto_AcceptancePolicy._(int v, String n) : super(v, n);
}

