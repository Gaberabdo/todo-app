// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_is_empty, must_be_immutable, import_of_legacy_library_into_null_safe, avoid_print


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates states) {
            if (states is AppInsertDatabaseState){
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, AppStates states) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              backgroundColor: Colors.white,
              key: scaffoldKey,
              appBar: AppBar(
                elevation: 0,
                foregroundColor: Colors.black,
                backgroundColor: Colors.white ,
                centerTitle: true,
                title: Container(
                  padding: EdgeInsetsDirectional.all(10),
                  child: Text(
                    cubit.title[cubit.index],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              body: ConditionalBuilder(
                builder: (context) => cubit.screen[cubit.index],
                condition: states is! AppGetDatabaseLoadingState,
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black12,
                elevation: 2,
                onPressed: () {
                  if (cubit.isButtonSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          data: dateController.text);
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextForm(
                                    type: TextInputType.emailAddress,
                                    obscureText: false,
                                    labelText: "Title Task",
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return " Title must not empty";
                                      }
                                      return null;
                                    },
                                    prefixIcon: Icons.text_fields,
                                    redius: 20,
                                    controller: titleController,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultTextForm(
                                    OnTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                    type: TextInputType.datetime,
                                    obscureText: false,
                                    labelText: "Time Task",
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return " Time must not empty";
                                      }
                                      return null;
                                    },
                                    prefixIcon: Icons.access_time_sharp,
                                    redius: 20,
                                    controller: timeController,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultTextForm(
                                    type: TextInputType.datetime,
                                    controller: dateController,
                                    OnTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-10-12'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    obscureText: false,
                                    labelText: "Data Task",
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return " data must not empty";
                                      }
                                      return null;
                                    },
                                    prefixIcon: Icons.calendar_today_outlined,
                                    redius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          elevation: 20,
                        ).closed.then((value) {
                      cubit.ChangeBottomSheetShow(
                          isShow: false, icon: Icons.edit_outlined);
                    });
                    cubit.ChangeBottomSheetShow(
                        isShow: true, icon: Icons.add_task_sharp);
                  }
                },
                child: Icon(
                  cubit.fabIcon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.red,
                type: BottomNavigationBarType.values[0],
                currentIndex: cubit.index,
                elevation: 0,
                onTap: (value) {
                  cubit.changeCurrent(value);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.menu,
                      ),
                      label: 'Task'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.done,
                      ),
                      label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: 'Archive'),
                ],
              ),
            );
          }),
    );
  }
}

