import 'package:flutter/material.dart';

import '../constants/constant.dart';

class TaskTitle extends StatelessWidget {
  const TaskTitle({
    Key? key,
    required this.title,
    required this.isChange,
    required this.checkboxChanget,
    required this.checkboxDelete,
  }) : super(key: key);
  final String title;
  final bool isChange;
  final void Function(bool?) checkboxChanget;
  final void Function() checkboxDelete;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 24,
            color: kTextDarkColor,
            decoration: isChange ? TextDecoration.lineThrough : null),
      ),
      trailing: Checkbox(
        activeColor: kPrimaryButton,
        value: isChange,
        onChanged: checkboxChanget,
      ),
      onLongPress: checkboxDelete,
    );
  }
}
