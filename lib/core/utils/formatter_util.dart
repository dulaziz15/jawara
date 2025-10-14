class FormatterUtil {
  static String formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} M';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)} jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} rb';
    }
    return amount.toStringAsFixed(0);
  }

  static String formatCompactCurrency(double amount) {
    if (amount >= 1000000) {
      double value = amount / 1000000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}jt';
    } else if (amount >= 1000) {
      double value = amount / 1000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}rb';
    }
    return amount.toStringAsFixed(0);
  }

  static String formatNumber(double number) {
    // Format number without decimal if it's whole number
    if (number == number.truncateToDouble()) {
      return number.truncate().toString();
    }
    return number.toStringAsFixed(1);
  }
}