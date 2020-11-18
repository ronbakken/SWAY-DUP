using System;
using Genesis.Ensure;

namespace Utility
{
    public struct Money : IEquatable<Money>, IComparable<Money>
    {
        public static readonly Money Empty = new Money();

        private readonly string currencyCode;
        private readonly long units;
        private readonly int nanoUnits;

        public Money(
            string currencyCode,
            long units,
            int nanoUnits)
        {
            Ensure.ArgumentCondition(units > 0 || nanoUnits <= 0, "If units is negative, nanoUnits must be <= 0.", nameof(units));
            Ensure.ArgumentCondition(units < 0 || nanoUnits >= 0, "If units is positive, nanoUnits must be >= 0.", nameof(units));

            this.currencyCode = currencyCode;
            this.units = units;
            this.nanoUnits = nanoUnits;
        }

        public bool IsEmpty => this == Empty;

        public string CurrencyCode => this.currencyCode;

        public long Units => this.units;

        public int NanoUnits => this.nanoUnits;

        public bool Equals(Money other) =>
            this.units == other.units && this.nanoUnits == other.nanoUnits && string.Equals(this.currencyCode, other.currencyCode);

        public override bool Equals(object obj)
        {
            if (obj is Money money)
            {
                return this.Equals(money);
            }

            return false;
        }

        public override int GetHashCode()
        {
            var hash = 17;

            hash = (hash * 23) + this.currencyCode?.GetHashCode() ?? 0;
            hash = (hash * 23) + this.units.GetHashCode();
            hash = (hash * 23) + this.nanoUnits.GetHashCode();

            return hash;
        }

        public int CompareTo(Money other)
        {
            if (!string.Equals(this.currencyCode, other.currencyCode))
            {
                throw new NotSupportedException("Cannot compare monies with different currency codes.");
            }

            var compareUnits = this.units.CompareTo(other.units);

            if (compareUnits != 0)
            {
                return compareUnits;
            }

            return this.nanoUnits.CompareTo(other.nanoUnits);
        }

        public override string ToString() =>
            $"{this.currencyCode ?? "<<NO CURRENCY CODE>>"}{this.units}.{Math.Abs(this.nanoUnits)}";

        public static bool operator ==(Money first, Money second) =>
            first.Equals(second);

        public static bool operator !=(Money first, Money second) =>
            !first.Equals(second);

        public static bool operator >(Money first, Money second) =>
            first.CompareTo(second) > 0;

        public static bool operator <(Money first, Money second) =>
            first.CompareTo(second) < 0;
    }
}
