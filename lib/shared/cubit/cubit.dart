import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks.dart';
import 'package:todo/modules/done_tasks.dart';
import 'package:todo/modules/tasks.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [Tasks(), DoneTasks(), Archive()];
  List<String> appBarTitle = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  Database database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];
  IconData floatingIcon = Icons.edit;
  IconData appBarIcon = Icons.lightbulb_outline;
  bool isOpened = false;
  bool isOn = false;

  var thememode;

  void changeindex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE task (id INTEGER PRIMARY KEY , title TEXT , date TEXT, time TEXT, status TEXT) ')
          .then((value) => print('table created'))
          .catchError(
              (error) => print('error when created ${error.toString()}'));
    }, onOpen: (database) {
      getdata(database);
      print('Database opend');
    }).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

  Future insertToDataBase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO task(title , date , time , status) VALUES("$title","$date","$time","Active")')
          .then((value) {
        print('$value inserted');
        emit(InsertDataBaseState());

        getdata(database);
      }).catchError(
              (error) => print('error when insertion ${error.toString()}'));
      return null;
    });
  }

  void getdata(database) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];
    emit(GetDataFromDataBaseLoadingState());
    database.rawQuery(' SELECT * FROM task ').then((value) {
      value.forEach((element) {
        if (element['status'] == 'Active') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else {
          archivetasks.add(element);
        }
      });

      emit(GetDataFromDataBaseState());
    });
  }

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isOpened = isShow;
    floatingIcon = icon;
    emit(ChangeBottomSheetState());
  }

  void changeAppBarIcon({
    @required bool isTurnedOn,
    @required IconData firsticon,
    @required IconData secondicon,
  }) {
    isOn = isTurnedOn;
    appBarIcon = isOn ? firsticon : secondicon;
    emit(ChangeAppBarState());
  }

  void updatedata({
    @required String status,
    @required int id,
  }) {
    database.rawUpdate('UPDATE task SET status = ? WHERE id = ?', [
      '$status',
      id,
    ]);
    getdata(database);
    emit(UpdateDataBaseRecordState());
  }

  void deletedata({@required int id}) async {
    database.rawDelete('DELETE FROM task WHERE id = ?', [id]).then((value) {
      getdata(database);
      emit(DeleteDataBaseRecordState());
    });
  }

  void changetheme({
    @required bool dark,
  }) {
    ThemeData darkmode = ThemeData(
        accentColor: Colors.red,
        brightness: Brightness.dark,
        primaryColor: Colors.amber);

    ThemeData lightmode = ThemeData(
        accentColor: Colors.pink,
        brightness: Brightness.dark,
        primaryColor: Colors.blue);

    if (dark == true) {
      thememode = darkmode;
      emit(ChangeToDarkTheme());
    } else {
      thememode = lightmode;
      emit(ChangeToLightTheme());
    }
  }
}
