// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/todo_states.dart';

import '../modules/archived_tasks/archived_tasks_screen.dart';
import '../modules/done_tasks/done_tasks_screen.dart';
import '../modules/new_tasks/new_tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());
  static TodoCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  bool initialValue = false;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen()
  ];
  List<String> titles = [" New Tasks ", " Done Tasks ", " Archived Tasks "];

  void changeIndex(int index) {
    currentIndex = index;
    emit(TodoChangeNavBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase("todo.db", version: 1,
        onCreate: (Database dataBase, int version) {
      print("Database Created");
      dataBase
          .execute(
              "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
          .then((value) => print("Table Created"))
          .catchError(
              (e) => print("Error when creating table ${e.toString()}"));
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print("Database Opened");
    }).then((value) {
      database = value;
      emit(TodoCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    await database.transaction((txn) => txn
            .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "New")',
        )
            .then((value) {
          print("$value Inserted Successfully");
          emit(TodoInsertToDatabaseState());
          getDataFromDataBase(database);
        }).catchError((error) =>
                print("Error when inserting new record ${error.toString()}")));
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(TodoGetDatabaseIsLoadingState());
    database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if (element['status'] == 'New') {
          newTasks.add(element);
        } else if (element['status'] == 'Done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(TodoGetDatabaseState());
    });
  }

  void updateData({required String status, required int id}) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [status, '$id']).then((value) {
      getDataFromDataBase(database);
      emit(TodoUpdateDatabaseState());
    });
  }

  void deleteData({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(TodoDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData iconbtn = Icons.edit;

  void changeBottomSeetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    iconbtn = icon;
    emit(TodoChangeNavBottomSheetState());
  }
}
