// ignore_for_file: avoid_print, prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo/shared/cubit/states.dart';

import '../../modules/archive_task/archive_task.dart';
import '../../modules/done-task/done_task.dart';
import '../../modules/new_task/new_task_screen.dart';
import '../network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int index = 0;
  void changeCurrent(int current) {
    index = current;
    emit(AppChangeBottomNabBarState());
  }

  List<Widget> screen = [
    NewTask(),
    DoneTask(),
    ArchiveTask(),
  ];
  List<String> title = [
    'New Task',
    'Done Task',
    'Archive Task',
  ];
  Database? database;
  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archiveTask = [];
  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE task (id INTEGER PRIMARY KEY, data TEXT ,title TEXT ,time TEXT ,status TEXT) ')
            .then((value) {
          print('DB Created');
        }).catchError((error) {
          print('Error whe create Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getFromDatabase(database);
        print('Database onOpen');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String data,
  }) async {
    database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO task(title,data,time,status) VALUES("$title","$data","$time","new")')
          .then((value) {
        print('$value Inserted successfully');
        emit(AppInsertDatabaseState());
        getFromDatabase(database).then((value) {
          emit(AppGetDatabaseState());
        });
      }).catchError((error) {
        print('Error whe Inserting New Record   ${error.toString()}');
      });
      return await null;
    });
  }

  getFromDatabase(database) {
    newTask = [];
    archiveTask = [];
    doneTask = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTask.add(element);
        } else if (element['status'] == 'done') {
          doneTask.add(element);
        } else {
          archiveTask.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDate({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate('UPDATE task SET status = ? WHERE id = ?',
        [status, '$id']).then((value) {
      print(status);
      getFromDatabase(database);
      emit(AppUpDateDatabaseState());
    });
  }

  void deleteDate({
    required int id,
  }) {
    database!.rawDelete('DELETE FROM task WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  IconData fabIcon = Icons.edit_outlined;
  bool isButtonSheetShown = false;
  // ignore: non_constant_identifier_names
  void ChangeBottomSheetShow({
    required bool isShow,
    required IconData icon,
  }) {
    isButtonSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;
  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
    } else {
      isDark = !isDark;
    }
    CacheHelper.putData(key: 'isDark', value: isDark).then((value) {
      emit(NewGetChangeAppThemeState());
    });
  }

}
