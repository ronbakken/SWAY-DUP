import 'package:decimal/decimal.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:intl/intl.dart';

class Reward {
  final String description;
  final Decimal barterValue;
  final Decimal cashValue;
  final RewardDto_Type type;

  String getTotalValueAsString([int digits = 2]) {
    if (barterValue == null && cashValue == null) {
      return '';
    }
    var formatter = NumberFormat.currency(locale: "en_US", symbol: '\$', decimalDigits: 0);
    return formatter.format((barterValue ?? Decimal.fromInt(0) + (cashValue ?? Decimal.fromInt(0))).toDouble());
  }

  String get cashValueAsString => '\$${cashValue.toStringAsFixed(2)}';
  String get barterValueAsString => '\$${barterValue.toStringAsFixed(2)}';

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
      barterValue: Decimal.fromInt(dto.barterValue) / Decimal.fromInt(100),
      cashValue: Decimal.fromInt(dto.cashValue) / Decimal.fromInt(100),
      description: dto.description,
      type: dto.type,
    );
  }
}
