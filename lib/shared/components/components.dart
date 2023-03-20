// ignore_for_file: import_of_legacy_library_into_null_safe, non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function() Function,
  required String text,
  required double reduis,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(reduis),
        color: background,
      ),
      child: MaterialButton(
        onPressed: Function(),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextForm({
  required TextEditingController controller,
  required TextInputType type,
  required bool obscureText,
  Color? color,
  required String labelText,
  required IconData prefixIcon,
  Function()? OnTap,
  bool click = true,
  IconData? suffixIcon,
  Function()? suffixIconfun,
  required double redius,
  required String? Function(String value) validator,
}) =>
    TextFormField(
      enabled: click,
      onTap: OnTap,
      obscureText: obscureText,
      validator: (value) {
        return null;
      }, // here it gives the error
      controller: controller,
      style: TextStyle(
        fontSize: 18.0,
        color: Colors.black,
      ),
      keyboardType: type,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: IconButton(
          onPressed: suffixIconfun,
          icon: Icon(
            suffixIcon,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(redius),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black12,
              foregroundColor: Colors.black,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['data']}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDate(status: 'done', id: model['id']);
              },
              icon: const Icon(Icons.check_box_outlined),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDate(status: 'archive', id: model['id']);
              },
              icon: const Icon(Icons.archive_outlined),
              color: Colors.red,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDate(id: model['id']);
      },
    );
Widget buildConditional({
  required List<Map> task,
}) =>
    ConditionalBuilder(
      condition: task.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(task[index], context),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.black38,
                ),
              ),
          itemCount: task.length),
      fallback: (context) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_open_sharp,
              size: 200,
              color: Colors.black26,
            ),
            Text(
              'NO TASK YET,PLEASE ADD NEW TASK',
              style: TextStyle(fontSize: 20, color: Colors.black),
            )
          ],
        ),
      ),
    );

void NavigatorGoTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

