// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/components.dart';
import '../../cubit/todo_cubit.dart';
import '../../cubit/todo_states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TodoCubit.get(context);
        return tasksBuilder(
            widget: ListView.separated(
                itemBuilder: (context, index) =>
                    buildTaskItem(cubit.archivedTasks[index], context),
                separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: Colors.deepOrange[50],
                        height: 0,
                        thickness: 1,
                      ),
                    ),
                itemCount: cubit.archivedTasks.length),
            tasks: cubit.archivedTasks);
      },
    );
  }
}
