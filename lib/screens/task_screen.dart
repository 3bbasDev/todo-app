import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../constants/TodoController.dart';
import '../constants/constant.dart';
import '../widget/tasks_list_widget.dart';
import 'add_task_screen.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: kSecondaryButton),
          boxShadow: [
            BoxShadow(
              color: kPrimaryButton,
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: floatButton(context),
      ),
      backgroundColor: kBackgrounColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<TodoController>(context).isLoading,
        child: Container(
          padding: const EdgeInsets.only(
            top: 60,
            left: 20,
            right: 20,
            bottom: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(
                      Icons.playlist_add_check,
                      size: 40,
                      color: kTextColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'To Do',
                      style: TextStyle(
                          fontSize: 28,
                          color: kTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: kSecondaryButton,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: kSecondaryButton),
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        Provider.of<TodoController>(context, listen: false)
                            .getTasks();
                      },
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.refresh,
                        color: kSecondaryButton,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${Provider.of<TodoController>(context, listen: false).tasks.length} Tasks',
                style: TextStyle(
                  fontSize: 28,
                  color: kTextColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TasksList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton floatButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AddTaskScreen((newtask) {
                // setState(() {
                //   Provider.of<TaskData>(context).listTasks.add(Task(title: newtask));
                //   Navigator.pop(context);
                // });
              }),
            ),
          ),
        );
      },
      backgroundColor: kPrimaryButton,
      child: Icon(Icons.add),
    );
  }
}
