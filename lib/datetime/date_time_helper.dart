// tarihi daha kolay bir şekilde saklamamıza yardımcı oalcak bir yöntem.
// convert DateTime object to a string yyyymmdd -- > bir tarihi - saat nesnesini yalnızca yıl,ay,gün olan bir dizeye dönüştürmek istiyorum.

String convertDateTimeToString(DateTime dateTime) {
  // year in the format --> yyyy
  String year = dateTime.year.toString();

  // month in the format -> mm
  String month = dateTime.month
      .toString(); // if (ayların 01 - 02 şeklinde yazılmasını istiyorum.)
  if (month.length == 1) {
    month == "0$month";
  }

  // day in the format -> dd
  String day = dateTime.day
      .toString(); // if (günlerin 01 - 02 şeklinde yazılmasını istiyorum.)
  if (day.length == 1) {
    day == "0$day";
  }

  // final format -> yyyymmdd hepsini bir araya getir.
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
