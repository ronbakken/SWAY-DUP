import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class DealTerms {
  final Deliverable deliverable;
  final Money cashValue;
  final Money serviceValue;
  final String serviceDescription;

  DealTerms({
    this.deliverable,
    this.cashValue,
    this.serviceValue,
    this.serviceDescription,
  });

  String getTotalValueAsString([int digits = 2]) {
    return ((serviceValue ?? Money.zero) + (cashValue ?? Money.zero)).toStringWithCurrencySymbol();
  }

  String get cashValueAsString => cashValue?.toStringWithCurrencySymbol() ?? '';

  String get serviceValueAsString => serviceValue?.toStringWithCurrencySymbol() ?? '';

  DealTerms copyWith({
    Deliverable deliverable,
    Money cashValue,
    Money serviceValue,
    String serviceDescription,
  }) {
    return DealTerms(
      deliverable: deliverable ?? this.deliverable,
      cashValue: cashValue ?? this.cashValue,
      serviceValue: serviceValue ?? this.serviceValue,
      serviceDescription: serviceDescription ?? this.serviceDescription,
    );
  }

  static DealTerms fromDto(DealTermsDto dto) {
    return DealTerms(
      deliverable: Deliverable.fromDto(dto.deliverable),
      cashValue: Money.fromDto(dto.cashValue),
      serviceValue: Money.fromDto(dto.serviceValue),
      serviceDescription: dto.serviceDescription,
    );
  }

  DealTermsDto toDto() {
    assert(deliverable != null);
    return DealTermsDto()
      ..deliverable = deliverable.toDto()
      ..cashValue = cashValue?.toDto()
      ..serviceValue = serviceValue?.toDto()
      ..serviceDescription = serviceDescription;
  }

  Proposal toProposal() {
    assert(deliverable != null);
    return (ProposalBuilder()
          ..deliverableDescription = deliverable.description
          ..cashValue = cashValue
          ..serviceDescription = serviceDescription
          ..serviceValue = serviceValue)
        .build();
  }
}
