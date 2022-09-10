import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/TodoController.dart';
import 'task_title_widget.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoController>(builder: (context, taskData, child) {
      return ListView.builder(
          itemCount: taskData.tasks.length,
          itemBuilder: (context, index) {
            return TaskTitle(
              isChange: taskData.tasks[index].isDone,
              title: taskData.tasks[index].title,
              checkboxChanget: (newValue) {
                taskData.isDoneTask(index, !taskData.tasks[index].isDone);
              },
              checkboxDelete: () {
                taskData.deleteTask(taskData.tasks[index]);
              },
            );
          });
    });
  }
}
