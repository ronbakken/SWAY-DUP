import 'package:inf/domain/domain.dart';
import 'package:meta/meta.dart';

class Proposal {
  final String deliverableDescription;
  final Money cashRewardValue;
  final String serviceDescription;
  final Money serviceValue;

  factory Proposal.fromJson(Map<String, dynamic> data) {
    return Proposal(
      deliverableDescription: data['deliverableDescription'],
      cashRewardValue: Money.fromJson(data['cashRewardValue']),
      serviceDescription: data['serviceDescription'],
      serviceValue: Money.fromJson(data['serviceValue']),
    );
  }

  Proposal({
    @required this.deliverableDescription,
    @required this.cashRewardValue,
    @required this.serviceDescription,
    @required this.serviceValue,
  });

  Proposal copyWith({
    String deliverableDescription,
    Money cashRewardValue,
    String serviceDescription,
    Money serviceValue,
  }) {
    return Proposal(
      deliverableDescription: deliverableDescription ?? this.deliverableDescription,
      cashRewardValue: cashRewardValue ?? this.cashRewardValue,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      serviceValue: serviceValue ?? this.serviceValue,
    );
  }

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

class ProposalBuilder {
  ProposalBuilder();

  String deliverableDescription;
  Money cashRewardValue;
  String serviceDescription;
  Money serviceValue;

  ProposalBuilder.fromProposal(Proposal proposal) {
    deliverableDescription = proposal.deliverableDescription;
    cashRewardValue = proposal.cashRewardValue;
    serviceDescription = proposal.serviceDescription;
    serviceValue = proposal.serviceValue;
  }

  Proposal build() {
    return Proposal(
      deliverableDescription: deliverableDescription,
      cashRewardValue: cashRewardValue,
      serviceDescription: serviceDescription,
      serviceValue: serviceValue,
    );
  }
}
