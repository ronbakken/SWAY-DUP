import 'dart:typed_data';

import 'package:decimal/decimal.dart';

enum RewardType { barter, cash, barterAndCash }

class Reward {
  final int id;
  final String description;
  final Decimal barterValue;
  final Decimal cashValue;
  final RewardType type;

  final String imageUrl;
  final Uint8List imageLowRes;

  String get totalValueAsString => '\$${((barterValue ?? Decimal.fromInt(0)) + (cashValue ?? Decimal.fromInt(0))).toStringAsFixed(2)}';
  String get cashValueAsString => '\$${cashValue.toStringAsFixed(2)}';
  String get barterValueAsString => '\$${barterValue.toStringAsFixed(2)}';

  Reward({
    this.id,
    this.type,
    this.description,
    this.barterValue,
    this.cashValue,
    this.imageUrl,
    this.imageLowRes,
  });
}
