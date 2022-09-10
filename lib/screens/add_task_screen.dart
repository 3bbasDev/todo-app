import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';

import '../constants/TodoController.dart';
import '../constants/constant.dart';
import '../models/task_data.dart';

class AddTaskScreen extends StatelessWidget {
  final Function addCallBack;
  AddTaskScreen(this.addCallBack);
  @override
  Widget build(BuildContext context) {
    String? newTask;
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Add New Task',
            style: TextStyle(
              fontSize: 30,
              color: kPrimaryButton,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            onChanged: (newValue) {
              newTask = newValue;
            },
            cursorColor: kSecondaryButton,
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'new task ...',
              focusColor: kSecondaryButton,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: kBackgrounColor, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Provider.of<TodoController>(context, listen: false)
                  .addTask(Task(title: newTask!, time: DateTime.now()));
              Navigator.pop(context);
            },
            child: Text(
              'Add',
              style: TextStyle(color: kTextColor),
            ),
            style: TextButton.styleFrom(
                backgroundColor: kBackgrounColor, primary: kPrimaryColor),
          )
        ],
      ),
    );
  }
}
