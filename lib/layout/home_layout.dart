// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, unused_local_variable, must_be_immutable, use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/todo_cubit.dart';
import 'package:todo_app/cubit/todo_states.dart';

class HomeLayout extends StatelessWidget {
  IconData myIcon = Icons.title_rounded;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  List<String> titles = [" New Tasks ", " Done Tasks ", " Archived Tasks "];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if (state is TodoInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = TodoCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              floatingActionButton: FloatingActionButton(
                elevation: 2,
                backgroundColor: Colors.deepOrange[200],
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit
                          .insertToDatabase(
                              title: titleController.text,
                              date: dateController.text,
                              time: timeController.text)
                          .then((value) {
                        titleController.clear();
                        dateController.clear();
                        timeController.clear();
                      });
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                          (context) => Container(
                            height: 400,
                            width: double.infinity,
                            padding: EdgeInsets.all(35),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    onTap: () {},
                                    keyboardType: TextInputType.name,
                                    controller: titleController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Title must not be empty";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          myIcon,
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        label: Text("Title")),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) => {
                                                timeController.text = value!
                                                    .format(context)
                                                    .toString()
                                              });
                                    },
                                    enableInteractiveSelection: false,
                                    keyboardType: TextInputType.none,
                                    controller: timeController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Time must not be empty ";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.watch_later_rounded),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        label: Text("Time")),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse("2022-12-30"))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    enableInteractiveSelection: false,
                                    keyboardType: TextInputType.none,
                                    controller: dateController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Date must not be empty ";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.calendar_today),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        label: Text("Date")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          elevation: 30,
                        )
                        .closed
                        .then((value) {
                      titleController.clear();
                      dateController.clear();
                      timeController.clear();

                      cubit.changeBottomSeetState(
                          isShow: false, icon: Icons.edit);
                    });

                    cubit.changeBottomSeetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.iconbtn),
              ),
              appBar: AppBar(
                elevation: 2,
                backgroundColor: Colors.deepOrange[200],
                title: Center(
                  child: Text(
                    titles[cubit.currentIndex],
                    style: TextStyle(
                        letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                fixedColor: Colors.deepOrange[200],
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: "Tasks",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: "Done",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: "Archived",
                  )
                ],
              ),
              body: ConditionalBuilder(
                condition: state is TodoGetDatabaseIsLoadingState,
                builder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
                fallback: (context) => cubit.screens[cubit.currentIndex],
              ));
        },
      ),
    );
  }
}
