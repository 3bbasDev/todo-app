class Task {
  String id;
  final String title;
  bool isDone;
  final DateTime time;
  Task(
      {required this.title,
      this.isDone = false,
      required this.time,
      this.id = "0"});

  void doneChange() {
    isDone = !isDone;
  }
}
