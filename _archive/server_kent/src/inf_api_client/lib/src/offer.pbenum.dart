///
//  Generated code. Do not modify.
//  source: offer.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class OfferDto_Status extends $pb.ProtobufEnum {
  static const OfferDto_Status unknown = OfferDto_Status._(0, 'unknown');
  static const OfferDto_Status active = OfferDto_Status._(1, 'active');
  static const OfferDto_Status inactive = OfferDto_Status._(2, 'inactive');
  static const OfferDto_Status closed = OfferDto_Status._(3, 'closed');
  static const OfferDto_Status archived = OfferDto_Status._(4, 'archived');

  static const $core.List<OfferDto_Status> values = <OfferDto_Status> [
    unknown,
    active,
    inactive,
    closed,
    archived,
  ];

  static final $core.Map<$core.int, OfferDto_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferDto_Status valueOf($core.int value) => _byValue[value];

  const OfferDto_Status._($core.int v, $core.String n) : super(v, n);
}

class OfferDto_StatusReason extends $pb.ProtobufEnum {
  static const OfferDto_StatusReason open = OfferDto_StatusReason._(0, 'open');
  static const OfferDto_StatusReason userClosed = OfferDto_StatusReason._(1, 'userClosed');
  static const OfferDto_StatusReason maximumReached = OfferDto_StatusReason._(2, 'maximumReached');
  static const OfferDto_StatusReason tosViolation = OfferDto_StatusReason._(3, 'tosViolation');
  static const OfferDto_StatusReason completed = OfferDto_StatusReason._(4, 'completed');
  static const OfferDto_StatusReason expired = OfferDto_StatusReason._(5, 'expired');

  static const $core.List<OfferDto_StatusReason> values = <OfferDto_StatusReason> [
    open,
    userClosed,
    maximumReached,
    tosViolation,
    completed,
    expired,
  ];

  static final $core.Map<$core.int, OfferDto_StatusReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferDto_StatusReason valueOf($core.int value) => _byValue[value];

  const OfferDto_StatusReason._($core.int v, $core.String n) : super(v, n);
}

class OfferDto_AcceptancePolicy extends $pb.ProtobufEnum {
  static const OfferDto_AcceptancePolicy manualReview = OfferDto_AcceptancePolicy._(0, 'manualReview');
  static const OfferDto_AcceptancePolicy automaticAcceptMatching = OfferDto_AcceptancePolicy._(1, 'automaticAcceptMatching');
  static const OfferDto_AcceptancePolicy allowNegotiation = OfferDto_AcceptancePolicy._(2, 'allowNegotiation');

  static const $core.List<OfferDto_AcceptancePolicy> values = <OfferDto_AcceptancePolicy> [
    manualReview,
    automaticAcceptMatching,
    allowNegotiation,
  ];

  static final $core.Map<$core.int, OfferDto_AcceptancePolicy> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferDto_AcceptancePolicy valueOf($core.int value) => _byValue[value];

  const OfferDto_AcceptancePolicy._($core.int v, $core.String n) : super(v, n);
}

