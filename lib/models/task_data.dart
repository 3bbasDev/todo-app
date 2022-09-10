import 'package:flutter/cupertino.dart';

import '../constants/TodoController.dart';
import 'task.dart';

class TodoController1 extends ChangeNotifier {
  List<Task> tasks = [
    Task(title: 'first', time: DateTime.now()),
    Task(title: 'second', time: DateTime.now()),
    Task(title: 'third', time: DateTime.now())
  ];

  void addTask(Task task) {
    tasks.add(Task(title: task.title, time: DateTime.now()));
    notifyListeners();
  }

  void updateTask(Task task) {
    task.doneChange();
    notifyListeners();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }
}
