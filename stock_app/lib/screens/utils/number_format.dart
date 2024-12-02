import 'package:intl/intl.dart';

String formatNumber(dynamic value) {
  if (value == null || value == 'N/A') return 'N/A';
  try {
    final parsedValue = double.parse(value.toString());
    return NumberFormat('#,###.##').format(parsedValue);
  } catch (e) {
    return 'N/A';
  }
}
