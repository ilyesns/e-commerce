DateTime get getCurrentTimestamp => DateTime.now();
DateTime dateTimeFromSecondsSinceEpoch(int seconds) {
  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}
