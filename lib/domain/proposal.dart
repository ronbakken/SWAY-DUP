import 'package:inf/domain/domain.dart';
import 'package:meta/meta.dart';

class Proposal {
  final String deliverableDescription;
  final Money cashRewardValue;
  final String serviceDescription;
  final Money serviceValue;

  factory Proposal.fromJson(Map<String, dynamic> data) {
    return Proposal._(
      deliverableDescription: data['deliverableDescription'],
      cashRewardValue: Money.fromJson(data['cashRewardValue']),
      serviceDescription: data['serviceDescription'],
      serviceValue: Money.fromJson(data['serviceValue']),
    );
  }

  Proposal._({
    @required this.deliverableDescription,
    @required this.cashRewardValue,
    @required this.serviceDescription,
    @required this.serviceValue,
  });

  @override
  String toString() {
    return 'Proposal{'
        'deliverableDescription: $deliverableDescription, '
        'cashRewardValue: $cashRewardValue, '
        'serviceDescription: $serviceDescription, '
        'serviceValue: $serviceValue'
        '}';
  }

  Map<String, dynamic> toJson() {
    return {
      'deliverableDescription': deliverableDescription,
      'cashRewardValue': cashRewardValue.toJson(),
      'serviceDescription': serviceDescription,
      'serviceValue': serviceValue.toJson(),
    };
  }
}
