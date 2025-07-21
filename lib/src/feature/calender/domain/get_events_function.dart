class GetEventsFunction {
  static final GetEventsFunction _instance = GetEventsFunction._internal();

  factory GetEventsFunction() {
    return _instance;
  }

  GetEventsFunction._internal();

  final Map<DateTime, List<String>> _events = {};

  List<String> getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  void addEvent(DateTime day, String event) {
    final key = DateTime(day.year, day.month, day.day);
    if (_events[key] == null) {
      _events[key] = [];
    }
    _events[key]!.add(event);
  }
}
