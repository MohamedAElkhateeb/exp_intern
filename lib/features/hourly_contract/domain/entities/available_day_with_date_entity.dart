class AvailableDayWithDateEntity {
  final String dayName;
  final String date;

  const AvailableDayWithDateEntity({
    required this.dayName,
    required this.date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AvailableDayWithDateEntity &&
              runtimeType == other.runtimeType &&
              dayName == other.dayName &&
              date == other.date;

  @override
  int get hashCode => dayName.hashCode ^ date.hashCode;
}