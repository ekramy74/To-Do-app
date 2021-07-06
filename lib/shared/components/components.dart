import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import 'package:todo/shared/cubit/cubit.dart';

Widget defaultFormFiled(
        {@required TextInputType type,
        @required TextEditingController controller,
        Function onSubmit,
        Function onChange,
        Function ontapped,
        @required Function validate,
        @required String label,
        @required IconData prefix,
        OutlineInputBorder border}) =>
    TextFormField(
      validator: validate,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      keyboardType: type,
      controller: controller,
      onTap: ontapped,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: border,
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.grey[400],
        child: Icon(
          Icons.archive_outlined,
          size: 30,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: Icon(
          Icons.delete_outlined,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        switch (direction) {
          case DismissDirection.startToEnd:
            AppCubit.get(context)
                .updatedata(status: 'archive', id: model['id']);

            break;
          case DismissDirection.endToStart:
            AppCubit.get(context).deletedata(id: model['id']);
            break;
          default:
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 45,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                icon: Icon(Icons.check_box_outlined),
                onPressed: () {
                  AppCubit.get(context)
                      .updatedata(status: 'done', id: model['id']);
                }),
          ],
        ),
      ),
    );

Widget taskbuilder({@required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (contect, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[200],
                ),
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 100,
              color: Colors.grey[500],
            ),
            Text(
              'No tasks yet, Please add some tasks',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey[500]),
            )
          ],
        ),
      ),
    );
