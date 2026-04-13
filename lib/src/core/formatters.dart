String formatPrice(int cents) {
  final euros = cents / 100;
  return '${euros.toStringAsFixed(2)} €';
}

String capitalize(String value) {
  if (value.isEmpty) {
    return value;
  }
  return value[0].toUpperCase() + value.substring(1);
}
