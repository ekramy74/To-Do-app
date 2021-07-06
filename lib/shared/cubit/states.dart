// abstract class CounterStates {}

// // class CounterInitialState extends CounterStates {}

// // class CounterPlusState extends CounterStates {
// //   final int counter;

// //   CounterPlusState(this.counter);
// // }

// // class CounterMinusState extends CounterStates {
// //   final int counter;

// //   CounterMinusState(this.counter);
// // }

abstract class AppStates {}

class AppInitialState extends AppStates {}

class ChangeBottomNavState extends AppStates {}

class CreateDataBaseState extends AppStates {}

class GetDataFromDataBaseState extends AppStates {}

class GetDataFromDataBaseLoadingState extends AppStates {}

class InsertDataBaseState extends AppStates {}

class UpdateDataBaseRecordState extends AppStates {}

class DeleteDataBaseRecordState extends AppStates {}

class ChangeBottomSheetState extends AppStates {}

class ChangeAppBarState extends AppStates {}

class ChangeToDarkTheme extends AppStates {}

class ChangeToLightTheme extends AppStates {}
