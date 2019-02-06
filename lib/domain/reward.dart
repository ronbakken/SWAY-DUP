import 'dart:typed_data';

import 'package:decimal/decimal.dart';

enum RewardType { barter, cash, barterAndCash }

class Reward {
  final String description;
  final Decimal barterValue;
  final Decimal cashValue;
  final RewardType type;

  final String imageUrl;
  final Uint8List imageLowRes;

  String  getTotalValueAsString([int digits = 2]) {
    return barterValue != null && cashValue != null ?   '\$${((barterValue ?? Decimal.fromInt(0)) + (cashValue ?? Decimal.fromInt(0))).toStringAsFixed(digits)}' : '';
  }
  String get cashValueAsString => '\$${cashValue.toStringAsFixed(2)}';
  String get barterValueAsString => '\$${barterValue.toStringAsFixed(2)}';

  Reward({
    this.type,
    this.description,
    this.barterValue,
    this.cashValue,
    this.imageUrl,
    this.imageLowRes,
  });
}
