import 'package:timeago/timeago.dart' as time_ago;

///
/// Created by Auro on 26/06/24
///

String timeInAgoShort(DateTime dateTime) {
  return time_ago.format(dateTime, locale: 'en_short', allowFromNow: true);
}

String timeInAgoFull(DateTime dateTime) {
  return time_ago.format(dateTime, locale: 'en', allowFromNow: true);
}

double calculateDiscountedAmount(double originalPrice, double discountPercent) {
  if (discountPercent < 0 || discountPercent > 100) {
    throw ArgumentError('Discount percent must be between 0 and 100');
  }

  double discountAmount = (originalPrice * discountPercent) / 100;
  return originalPrice - discountAmount;
}
