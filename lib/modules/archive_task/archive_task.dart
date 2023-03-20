
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchiveTask extends StatelessWidget {
  const ArchiveTask({ Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var task =AppCubit.get(context).archiveTask;
        return buildConditional(
          task: task,
        );
      },
    );
  }
}
