import 'package:intl/intl.dart';

/*
ICU Name                   Skeleton

DAY                          d
ABBR_WEEKDAY                 E
WEEKDAY                      EEEE
ABBR_STANDALONE_MONTH        LLL
STANDALONE_MONTH             LLLL
NUM_MONTH                    M
NUM_MONTH_DAY                Md
NUM_MONTH_WEEKDAY_DAY        MEd
ABBR_MONTH                   MMM
ABBR_MONTH_DAY               MMMd
ABBR_MONTH_WEEKDAY_DAY       MMMEd
MONTH                        MMMM
MONTH_DAY                    MMMMd
MONTH_WEEKDAY_DAY            MMMMEEEEd
ABBR_QUARTER                 QQQ
QUARTER                      QQQQ
YEAR                         y
YEAR_NUM_MONTH               yM
YEAR_NUM_MONTH_DAY           yMd
YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
YEAR_ABBR_MONTH              yMMM
YEAR_ABBR_MONTH_DAY          yMMMd
YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
YEAR_MONTH                   yMMMM
YEAR_MONTH_DAY               yMMMMd
YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
YEAR_ABBR_QUARTER            yQQQ
YEAR_QUARTER                 yQQQQ
HOUR24                       H
HOUR24_MINUTE                Hm
HOUR24_MINUTE_SECOND         Hms
HOUR                         j
HOUR_MINUTE                  jm
HOUR_MINUTE_SECOND           jms
HOUR_MINUTE_GENERIC_TZ       jmv
HOUR_MINUTE_TZ               jmz
HOUR_GENERIC_TZ              jv
HOUR_TZ                      jz
MINUTE                       m
MINUTE_SECOND                ms
SECOND                       s
*/
class DateUtil {
  static String dateToString(DateTime date, {String mask = "dd/MM/yyyy"}) {
    DateFormat formatter = DateFormat(mask);
    return formatter.format(date);
  }

  static DateTime StringToDate(String date, {String mask = "dd/MM/yyyy"}) {
    DateFormat formatter = DateFormat(mask);
    return formatter.parse(date);
  }

  static bool equals(DateTime d1, DateTime d2, {String mask = "dd/MM/yyyy"}) {
    String ds1 = dateToString(d1, mask: mask);
    String ds2 = dateToString(d2, mask: mask);
    return ds1 == ds2;
  }

  static Duration diferenca(DateTime d1, DateTime d2) {
    return d1.difference(d2);
  }

  static DateTime getUltimaDataHoraDoMesByDate(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  static DateTime getPrimeiraDataHoraDoMesByDate(DateTime date) {
    return DateTime(date.year, date.month, 1, 0, 0, 0, 0, 0);
  }
}
