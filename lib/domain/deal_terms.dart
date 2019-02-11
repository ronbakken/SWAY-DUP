import 'package:inf/domain/domain.dart';

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
}
