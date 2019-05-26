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

enum ProposalResponseType { accept, counter, reject }

class ProposalResponse {
  const ProposalResponse._({@required this.type, this.message});

  const ProposalResponse.accept({this.message}) : this.type = ProposalResponseType.accept;
  const ProposalResponse.counter({this.message}) : this.type = ProposalResponseType.counter;
  const ProposalResponse.reject({this.message}) : this.type = ProposalResponseType.reject;

  final ProposalResponseType type;
  final String message;

  bool get isAccepted => type == ProposalResponseType.accept;
  bool get isCountered => type == ProposalResponseType.counter;
  bool get isRejected => type == ProposalResponseType.reject;
  bool get hasMessage => message != null && message.isNotEmpty;

  factory ProposalResponse.fromJson(Map<String, dynamic> data) {
    return ProposalResponse._(
      type: ProposalResponseType.values.firstWhere((val) => val.toString() == data["type"]),
      message: data["message"],
    );
  }

  @override
  String toString() {
    return 'ProposalResponse{'
        'type: $type, '
        'message: $message, '
        '}';
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'message': message,
    };
  }
}
