import 'package:inf/domain/domain.dart';
import 'package:meta/meta.dart';

class Proposal {
  final String deliverableDescription;
  final Money cashValue;
  final String serviceDescription;
  final Money serviceValue;

  factory Proposal.fromJson(Map<String, dynamic> data) {
    return Proposal._(
      deliverableDescription: data['deliverableDescription'],
      cashValue: Money.fromJson(data['cashValue']),
      serviceDescription: data['serviceDescription'],
      serviceValue: Money.fromJson(data['serviceValue']),
    );
  }

  Proposal._({
    @required this.deliverableDescription,
    @required this.cashValue,
    @required this.serviceDescription,
    @required this.serviceValue,
  });

  Proposal copyWith({
    String deliverableDescription,
    Money cashValue,
    String serviceDescription,
    Money serviceValue,
  }) {
    return Proposal._(
      deliverableDescription: deliverableDescription ?? this.deliverableDescription,
      cashValue: cashValue ?? this.cashValue,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      serviceValue: serviceValue ?? this.serviceValue,
    );
  }

  @override
  String toString() {
    return 'Proposal{'
        'deliverableDescription: $deliverableDescription, '
        'cashValue: $cashValue, '
        'serviceDescription: $serviceDescription, '
        'serviceValue: $serviceValue'
        '}';
  }

  Map<String, dynamic> toJson() {
    return {
      'deliverableDescription': deliverableDescription,
      'cashValue': cashValue?.toJson(),
      'serviceDescription': serviceDescription,
      'serviceValue': serviceValue?.toJson(),
    };
  }
}

class ProposalBuilder {
  ProposalBuilder();

  ProposalBuilder.fromProposal(Proposal proposal) {
    deliverableDescription = proposal.deliverableDescription;
    cashValue = proposal.cashValue;
    serviceDescription = proposal.serviceDescription;
    serviceValue = proposal.serviceValue;
  }

  String deliverableDescription;
  Money cashValue;
  String serviceDescription;
  Money serviceValue;

  Proposal build() {
    return Proposal._(
      deliverableDescription: deliverableDescription,
      cashValue: cashValue,
      serviceDescription: serviceDescription,
      serviceValue: serviceValue,
    );
  }
}

class ProposalState {
  static final applied = ProposalState._('APPLIED');
  static final negotiation = ProposalState._('NEGOTIATION');
  static final disputed = ProposalState._('DISPUTED');
  static final deal = ProposalState._('DEAL');
  static final done = ProposalState._('DONE');

  ProposalState._(this.label);

  final String label;
}
