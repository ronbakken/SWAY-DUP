import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class DealTerms {
  final Deliverable deliverable;
  final Reward reward;

  DealTerms({this.deliverable, this.reward});

  DealTerms copyWith({
    Deliverable deliverable,
    Reward reward,
  }) {
    return DealTerms(
      deliverable: deliverable ?? this.deliverable,
      reward: reward ?? this.reward,
    );
  }

  static DealTerms fromDto(DealTermsDto dto) {
    return DealTerms(
      deliverable: Deliverable.fromDto(dto.deliverable),
      reward: Reward.fromDto(dto.reward),
    );
  }
}
