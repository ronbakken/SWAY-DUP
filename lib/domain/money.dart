import 'package:decimal/decimal.dart';
import 'package:inf_api_client/inf_api_client.dart';

class Money {
  static final zero = Money(Decimal.fromInt(0));

  const Money(this.value, {this.currencyCode = 'USD'});

  final Decimal value;
  final String currencyCode;

  static Money fromDto(MoneyDto dto) {
    final units = Decimal.fromInt(dto.units);
    final nanos = Decimal.fromInt(dto.nanos);
    final value = units + nanos / Decimal.fromInt(10000000);
    return Money(
      value,
      currencyCode: dto.currencyCode.isNotEmpty ? dto.currencyCode : 'USD',
    );
  }

  static Money tryParse(String value, [String currencyCode = 'USD']) {
    try {
      return Money.fromDecimal(Decimal.parse(value), currencyCode);
    } on FormatException {
      return null;
    }
  }

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money.tryParse(json['value'], json['currency']);
  }

  Money.fromDecimal(this.value, [this.currencyCode = 'USD']);

  Money.fromInt(int value, [this.currencyCode = 'USD']) : value = Decimal.fromInt(value);

  Money operator +(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value + other.value, other.currencyCode);
  }

  Money operator -(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value - other.value, other.currencyCode);
  }

  Money operator *(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value * other.value, other.currencyCode);
  }

  Money operator %(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value % other.value, other.currencyCode);
  }

  Money operator /(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value / other.value, other.currencyCode);
  }

  bool operator >(Money other) {
    assert(currencyCode == other.currencyCode);
    return value > other.value;
  }

  bool operator <(Money other) {
    assert(currencyCode == other.currencyCode);
    return value < other.value;
  }

  @override
  bool operator ==(Object other) {
    return other is Money && other.value == value && other.currencyCode == currencyCode;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString([int digits = 2]) {
    return value.toStringAsFixed(digits);
  }

  String toStringWithCurrencySymbol([int digits = 2]) {
    // TODO: Decide currency symbol based on currency used.
    return "\$ ${this.toString(digits)}";
  }

  double toDouble() => value.toDouble();

  MoneyDto toDto() {
    var units = value.truncate();
    var nanos = (value - units) * Decimal.fromInt(10000000);

    return MoneyDto()
      ..currencyCode = currencyCode
      ..units = units.toInt()
      ..nanos = nanos.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value.toString(),
      'currency': currencyCode,
    };
  }
}
