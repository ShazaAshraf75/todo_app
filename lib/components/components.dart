import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/cubit/todo_cubit.dart';

//Hello Worldddddd!!!!!!!!!!!!
Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      background: Container(
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      secondaryBackground: model['status'] != 'Archived'
          ? Container(
              color: Colors.green,
              child: const Icon(
                Icons.archive,
                color: Colors.white,
                size: 30,
              ),
            )
          : null,
      onDismissed: model['status'] == 'Archived'
          ? (direction) {
              TodoCubit.get(context).deleteData(id: model['id']);
            }
          : (direction) {
              if (direction == DismissDirection.startToEnd) {
                TodoCubit.get(context).deleteData(id: model['id']);
              } else {
                TodoCubit.get(context)
                    .updateData(status: 'Archived', id: model['id']);
              }
            },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.lightBlue[200],
              radius: 45,
              child: Text(
                model["time"],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model["title"],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[300]),
                  ),
                  Text(
                    model["date"],
                    style:
                        TextStyle(fontSize: 12, color: Colors.deepOrange[200]),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            if (model['status'] != 'Done')
              IconButton(
                  onPressed: () {
                    TodoCubit.get(context)
                        .updateData(status: 'Done', id: model['id']);
                  },
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.lightBlue[200],
                  )),
          ],
        ),
      ),
    );

Widget tasksBuilder({required Widget widget, required List<Map> tasks}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => widget,
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              "No tasks yet, Please add some tasks",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
