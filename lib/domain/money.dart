import 'package:decimal/decimal.dart';
import 'package:inf_api_client/inf_api_client.dart';

class Money {
  final String currencyCode;
  final Decimal value;

  Money(
    this.value, {
    this.currencyCode = 'USD',
  });

  static Money fromDto(MoneyDto dto) {
    var units = Decimal.fromInt(dto.units);
    var nanos = Decimal.fromInt(dto.nanos);

    var value = units + nanos / Decimal.fromInt(10000000);

    return Money(
      value,
      currencyCode: dto.currencyCode,
    );
  }

  MoneyDto toDto() {
    var units = value.truncate();
    var nanos = (value - units) * Decimal.fromInt(10000000);

    return MoneyDto()
      ..currencyCode = currencyCode
      ..units = units.toInt()
      ..nanos = nanos.toInt();
  }

  Money.fromDecimal(this.value, {this.currencyCode = 'USD'});

  Money.fromInt(int value, {this.currencyCode = 'USD'}) : value = Decimal.fromInt(value);

  Money operator +(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value + other.value, currencyCode: other.currencyCode);
  }

  Money operator -(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value - other.value, currencyCode: other.currencyCode);
  }

  Money operator *(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value * other.value, currencyCode: other.currencyCode);
  }

  Money operator %(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value % other.value, currencyCode: other.currencyCode);
  }

  Money operator /(Money other) {
    assert(currencyCode == other.currencyCode);
    return Money.fromDecimal(value / other.value, currencyCode: other.currencyCode);
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
    return other is Money && other.value ==value && other.currencyCode ==currencyCode;
  }

  @override
  int get hashCode => value.hashCode;


  @override
  String toString([int digits = 2]) {
    return value.toStringAsFixed(digits);
  }

  double toDouble() {
    return value.toDouble();
  }

  static Money tryParse(String value) {
    try {
      return Money.fromDecimal(Decimal.parse(value));
    } on FormatException {
      return null;
    }
  }
}
