import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo/shared/components/components.dart';
import 'package:intl/intl.dart';

import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertDataBaseState) Navigator.pop(context);
          if (state is ChangeToLightTheme)
            AppCubit.get(context).appBarIcon = Icons.lightbulb;
          if (state is ChangeToDarkTheme)
            AppCubit.get(context).appBarIcon = Icons.lightbulb_outline;
        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.appBarTitle[cubit.currentIndex]),
              centerTitle: true,
              backgroundColor: Colors.yellow[800],
              actions: [
                IconButton(
                  icon: Icon(cubit.appBarIcon),
                  onPressed: () {
                    // cubit.changeAppBarIcon(
                    //     isTurnedOn: true,
                    //     firsticon: Icons.lightbulb,
                    //     secondicon: Icons.lightbulb_outline);

                    // cubit.changetheme(dark: true);
                  },
                )
              ],
            ),
            body: ConditionalBuilder(
                condition: state is! GetDataFromDataBaseLoadingState,
                builder: (BuildContext context) =>
                    cubit.screens[cubit.currentIndex],
                fallback: (BuildContext context) => Center(
                      child: CircularProgressIndicator(),
                    )),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.yellow[800],
              child: Icon(cubit.floatingIcon),
              onPressed: () {
                if (cubit.isOpened) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormFiled(
                                  type: TextInputType.text,
                                  controller: titleController,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormFiled(
                                    type: TextInputType.datetime,
                                    controller: timeController,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task time',
                                    prefix: Icons.watch_later_outlined,
                                    ontapped: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) => {
                                                timeController.text = value
                                                    .format(context)
                                                    .toString()
                                              });
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormFiled(
                                    type: TextInputType.datetime,
                                    controller: dateController,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task date',
                                    prefix: Icons.calendar_today_outlined,
                                    ontapped: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2021-12-31'))
                                          .then((value) => {
                                                dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(value)
                                              });
                                    }),
                              ],
                            ),
                          ),
                        ),
                        elevation: 15,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.yellow[800],
              showSelectedLabels: true,
              iconSize: 25,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeindex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu_rounded),
                    label: 'Tasks'.toUpperCase()),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outlined),
                    label: ' Done'.toUpperCase()),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archive'.toUpperCase())
              ],
            ),
          );
        },
      ),
    );
  }
}
