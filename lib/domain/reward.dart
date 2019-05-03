import 'package:inf/domain/money.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:intl/intl.dart';

class Reward {
  final String description;
  final Money barterValue;
  final Money cashValue;
  final RewardDto_Type type;

  String getTotalValueAsString([int digits = 2]) {
    if (barterValue == null && cashValue == null) {
      return '';
    }
    var formatter = NumberFormat.currency(locale: "en_US", symbol: '\$', decimalDigits: 0);
    return formatter.format((barterValue ?? Money.zero + (cashValue ?? Money.zero)).toDouble());
  }

  String get cashValueAsString => '\$${cashValue.toString()}';
  String get barterValueAsString => '\$${barterValue.toString()}';

  Reward({
    this.type,
    this.description,
    this.barterValue,
    this.cashValue,
  });

  Reward copyWith({
    type,
    description,
    barterValue,
    cashValue,
  }) {
    return Reward(
      type: type ?? this.type,
      description: description ?? this.description,
      barterValue: barterValue ?? this.barterValue,
      cashValue: cashValue ?? this.cashValue,
    );
  }

  static Reward fromDto(RewardDto dto) {
    return Reward(
      barterValue: Money.fromDto(dto.barterValue),
      cashValue: Money.fromDto(dto.cashValue),
      description: dto.description,
      type: dto.type,
    );
  }

  RewardDto toDto()
  {
    assert(barterValue != null);
    assert(cashValue !=null);
     return RewardDto()
     ..barterValue = barterValue.toDto()
     ..barterValue = cashValue.toDto()
     ..description = description ?? ''
     ..type =type;
  }
}
